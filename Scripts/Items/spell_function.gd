extends Resource
class_name SpellFunction

func requires_selection() -> bool:
    return false;

func requires_depth() -> bool:
    return false;

func specification() -> Enum.SpellSpecification:
    return Enum.SpellSpecification.None;

func spell_name() -> StringName:
    return &"SPELL_NONE";

func cast(user: Entity, target: Entity, depth: int) -> int:
    return 0;
