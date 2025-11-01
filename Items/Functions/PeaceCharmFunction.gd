extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (decision == Enum.Decision.Attack): return;
	if (user is not Player): return;
	if (randi_range(0, 100) <= 40):
		user.health += int(user.max_health * 0.4);
		ItemUtils.show_activation_toast("Peace Charm");
