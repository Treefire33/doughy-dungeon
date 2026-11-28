class_name StatusEffect

var effect: Enum.StatusEffect;
var turns_left: int;
var stat_mods: Array[StatModifier] = [];

static func apply_effect(entity: Entity, effect_strength: int, effect: Enum.StatusEffect):
    var new_effect: StatusEffect = StatusEffect.new();
    new_effect.effect = effect;

    match (effect):
        Enum.StatusEffect.Burn:
            new_effect.turns_left = 5;
        Enum.StatusEffect.Poison:
            new_effect.turns_left = 10;
        Enum.StatusEffect.Stun:
            new_effect.turns_left = max(1, effect_strength);
            entity.turn_points -= new_effect.turns_left;
        Enum.StatusEffect.Influence:
            new_effect.turns_left = 5;
        Enum.StatusEffect.Tired:
            new_effect.turns_left = 4;
        Enum.StatusEffect.Sadness:
            new_effect.turns_left = 3;
        Enum.StatusEffect.Bravery:
            new_effect.turns_left = 4;
            var new_modifier = StatModifier.new(
                Enum.ModifierType.Additive, 
                Enum.StatType.Attack, 
                2
            );
            entity.stat_modifiers.append(new_modifier);
            entity.stat_modifiers.sort_custom(StatModifier._sort_stat_mods);
            new_effect.stat_mods.append(new_modifier);
        Enum.StatusEffect.Exhausted:
            new_effect.turns_left = 6;
        Enum.StatusEffect.Wet:
            new_effect.turns_left = 8;
            var new_modifier = StatModifier.new(
                Enum.ModifierType.Additive, 
                Enum.StatType.Attack, 
                -1
            );
            entity.stat_modifiers.append(new_modifier);
            entity.stat_modifiers.sort_custom(StatModifier._sort_stat_mods);
            new_effect.stat_mods.append(new_modifier);

    ItemUtils.show_custom_toast("%s applied to %s" % [Enum.StatusEffect.keys()[effect], entity.name]);
    entity.status_effects.append(new_effect);
    entity.update_status_notifs();

static func clean_effects(entity: Entity):
    var to_remove: Array[int] = [];
    var i: int = 0;
    for effect in entity.status_effects:
        if (effect.turns_left > 0): i += 1; continue;
        to_remove.append(i);
        i += 1;
    
    for index in to_remove:
        if (entity.status_effects.size() < index): continue;
        var effect = entity.status_effects[index];
        for stat_mod in effect.stat_mods:
            entity.stat_modifiers.erase(stat_mod);
        entity.stat_modifiers.sort_custom(StatModifier._sort_stat_mods);
        entity.status_effects.remove_at(index);

static func has_effect(entity: Entity, effect_id: Enum.StatusEffect):
    return entity.status_effects.find_custom(func(effect): return effect.effect == effect_id) > -1;

static var status_icons: SpriteFrames = preload("res://Sprites/Icons/StatusIcons.aseprite");
static func get_effect_icon(effect: Enum.StatusEffect) -> Texture2D:
    return status_icons.get_frame_texture(StringName(Enum.StatusEffect.keys()[effect]), 0);

func update_effect(entity: Entity):
    if (turns_left <= 0): return;

    match (effect):
        Enum.StatusEffect.Burn:
            entity.health -= 2;
        Enum.StatusEffect.Poison:
            entity.health -= 1;
    
    turns_left -= 1;
    return;
