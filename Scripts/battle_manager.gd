extends Node
class_name BattleManager

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
        Enum.Decision.Attack, Enum.Decision.AttackHeavy, Enum.Decision.SpellAttack:
            return "attacked";
        Enum.Decision.SpellDefend:
            return "defended";
        Enum.Decision.Rest:
            return "rested";
    return "???";

func do_turn(room_manager: RoomManager):
    # Get player's decision
    player.play_anim(Enum.PlayerAnimation.Idle);
    var decision: Enum.Decision = Enum.Decision.Rest;
    var selected_enemy: Enemy = null;
    var decision_count: int = -1;
    if (player.turn_points > 0):
        room_manager.request_decision.emit();
        var decision_info = await room_manager.player_ui.player_decision;
        decision = decision_info[0];
        selected_enemy = decision_info[1];
        decision_count = decision_info[2];

    # Do turns
    current_entities.sort_custom(_sort_entity);
    for entity in current_entities:
        if (entity is Enemy): entity.update_health();
        if (entity.health <= 0): continue;
        entity.defending_duration -= 1;
        entity.turn_points += 1;
        if (entity.turn_points <= 0): continue;

        var turn_cost: int = 0;
        if (entity is Player):
            if (decision_count == -1): continue;
            turn_cost = entity.turn(selected_enemy, decision, decision_count);
            ItemUtils.activate_items(player, "decision", player, selected_enemy, decision);

            if (player.stamina <= 0):
                player.play_anim(Enum.PlayerAnimation.Rest);
            else:
                player.play_anim(player.decision_to_animation[decision]);

            if (selected_enemy != null && selected_enemy.health <= 0):
                ItemUtils.activate_items(player, "enemy_kill", player, selected_enemy);
                Audio.play_audio(Audio.die_sfx);
                player.coins += int(selected_enemy.get_coin_drops() * room_manager.room_multiplier);
                selected_enemy.visible = false;
        else:
            var enemy_decision = entity.get_decision(player, room_manager.room_difficulty);
            var enemy_target = entity.get_target(player, get_enemies());
            turn_cost = entity.turn(enemy_target, enemy_decision);
            ItemUtils.activate_items(player, "decision", entity, enemy_target, enemy_decision);
            ToastParty.show({
                "text": entity.name + " " + decision_text(decision) + "!",
                "text_size": Settings.toast_size,
                "bgcolor": Color(0, 0, 0, 1),
                "color": Color(1, 1, 1, 1),
                "gravity": "top",
                "direction": "right",
            });
        
        entity.turn_points -= turn_cost;
        entity.update_shield();

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
