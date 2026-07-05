class_name StatusEffect

var effect: Enum.StatusEffect;
var turns_left: int;

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

    ItemUtils.show_custom_toast("%s applied to %s" % [Enum.StatusEffect.keys()[effect], entity.name]);
    entity.status_effects.append(new_effect);

static func clean_effects(entity: Entity):
    var to_remove: Array[int] = [];
    var i: int = 0;
    for effect in entity.status_effects:
        if (effect.turns_left > 0): i += 1; continue;
        to_remove.append(i);
        i += 1;
    
    for index in to_remove:
        entity.status_effects.remove_at(index);

static func has_effect(entity: Entity, effect_id: Enum.StatusEffect):
    return entity.status_effects.find_custom(func(effect): return effect.effect == effect_id) > -1;

func update_effect(entity: Entity):
    if (turns_left <= 0): return;

    match (effect):
        Enum.StatusEffect.Burn:
            entity.health -= 2;
        Enum.StatusEffect.Poison:
            entity.health -= 1;
    
    turns_left -= 1;
    return;
