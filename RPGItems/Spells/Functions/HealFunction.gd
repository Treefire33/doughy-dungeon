extends SpellFunction

func requires_selection() -> bool:
    return false;

func specification() -> Enum.SpellSpecification:
    return Enum.SpellSpecification.Special;

func spell_name() -> StringName:
    return &"Heal";

func cast(user: Entity, target: Entity, depth: int):
    @warning_ignore("narrowing_conversion")
    user.health += user.max_health * 0.5;
    user.stamina -= 5;
    return depth;
