extends Node
class_name BattleManager

signal request_decision();
var current_entities: Array[Entity] = [];
var player: Player = null;

func _sort_entity(entityA: Entity, entityB: Entity):
    return entityA.speed > entityB.speed;

func start_battle(enemies: Array[Enemy], player: Player):
    self.player = player;
    current_entities.append(player);
    current_entities.append_array(enemies);
    current_entities.sort_custom(_sort_entity);

func decision_text(decision: Enum.Decision):
    match (decision):
        Enum.Decision.Attack, Enum.Decision.AttackHeavy:
            return "attacked";
        Enum.Decision.Spell:
            return "casted a spell";
        Enum.Decision.SpellEnemyDefend:
            return "defended";
        Enum.Decision.Rest:
            return "rested";
    return "???";

func do_turn(room_manager: RoomManager):
    # Update turn order
    current_entities.sort_custom(_sort_entity);
    room_manager.player_ui.reset_turn_order();
    for entity in current_entities:
        room_manager.player_ui.add_to_turn_order(entity);

    # Get player's decision
    player.play_anim(Enum.PlayerAnimation.Idle);
    var decision: Enum.Decision = Enum.Decision.Rest;
    var selected_enemy: Enemy = null;
    var decision_count: int = -1;
    var selected_spell: SpellFunction = null;
    if (player.turn_points > 0):
        request_decision.emit();
        var decision_info = await room_manager.player_ui.decision_panel.decision;
        decision = decision_info[0];
        selected_enemy = decision_info[1];
        decision_count = decision_info[2];
        selected_spell = decision_info[3];

    # Do turns
    for entity in current_entities:
        if (entity.health <= 0): continue;

        for effect in entity.status_effects:
            effect.update_effect(entity);

        entity.defending_duration -= 1;
        if (entity.turn_points <= 0): continue;

        if (StatusEffect.has_effect(entity, Enum.StatusEffect.Crystallized)): continue;
        var turn_cost: int = 0;
        if (entity is Player):
            if (decision_count == -1): continue;
            turn_cost = entity.turn(selected_enemy, decision, decision_count, selected_spell);
            
            if (selected_spell == null):
                ItemUtils.activate_items(player, "decision", ItemFunction.ItemFunctionArgs.new_decision_args(player, selected_enemy, decision));
            else:
                ItemUtils.activate_items(player, "decision", ItemFunction.ItemFunctionArgs.new_decision_args(
                    player, selected_enemy, decision, 
                    selected_spell.specification(), selected_spell.spell_name()
                ));

            if (player.stamina <= 0):
                player.play_anim(Enum.PlayerAnimation.Rest);
            else:
                player.play_anim(player.decision_to_animation[decision]);

            if (selected_enemy != null && selected_enemy.health <= 0):
                ItemUtils.activate_items(player, "enemy_kill", ItemFunction.ItemFunctionArgs.new_enemy_kill_args(player, selected_enemy));
                Audio.play_audio(Audio.die_sfx);
                player.coins += room_manager.difficulty_adjust(selected_enemy.get_coin_drops() * room_manager.room_multiplier);
                selected_enemy.visible = false;
        else:
            var enemy_decision = entity.get_decision(player, room_manager.room_difficulty);
            var enemy_target = entity.get_target(player, get_enemies());
            turn_cost = entity.turn(enemy_target, enemy_decision, 1, selected_spell);
            ItemUtils.activate_items(player, "decision", ItemFunction.ItemFunctionArgs.new_decision_args(entity, enemy_target, enemy_decision));
            ToastParty.show({
                "text": entity.name + " " + decision_text(enemy_decision) + "!",
                "text_size": Settings.toast_size,
                "bgcolor": Color(0, 0, 0, 1),
                "color": Color(1, 1, 1, 1),
                "gravity": "top",
                "direction": "right",
            });
        
        if (StatusEffect.has_effect(entity, Enum.StatusEffect.Exhausted)):
            turn_cost += 1;
        entity.turn_points -= turn_cost;
    
    # cleanup
    for entity in current_entities:
        if (entity is Enemy): entity.update_health();
        StatusEffect.clean_effects(entity);

        entity.turn_points += 1; # give a much needed turn point
        entity.update_shield();
        entity.update_status_notifs();

func battle_active() -> bool:
    var enemies_dead: int = 0;
    for entity in current_entities:
        if (entity is Player && entity.health <= 0): return false;
        if (entity.health <= 0): enemies_dead += 1;
    return enemies_dead != current_entities.size() - 1;

func clear_battle():
    for entity in current_entities:
        if (entity is Player): continue;
        entity.queue_free();
    current_entities.clear();
    player.turn_points = 1;

func get_enemies() -> Array[Enemy]:
    return current_entities.filter(func(entity): return entity is Enemy);
