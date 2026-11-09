extends SpellFunction

func requires_selection() -> bool:
    return false;

func cast(user: Entity, target: Entity, depth: int):
    return depth;
