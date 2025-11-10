extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
    if (user is not Player): return;
    if (randi_range(0, 100) < 10):
        user.health += (int)(user.max_health * 0.5);
        ItemUtils.show_custom_toast("The blessing of a long lost town makes its way to you.");
