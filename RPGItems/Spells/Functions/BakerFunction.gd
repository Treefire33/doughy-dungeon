extends SpellFunction

func cast(user: Entity, target: Entity, depth: int) -> int:
    user.health += user.max_health * 0.35;
    user.stamina += user.max_stamina * 0.35;
    return 2;
