extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (target == null): return;
	if (user is not Player): return;
	if (decision != Enum.Decision.Attack): return;
	if (target.defending_duration != 0): return;
	if (randi_range(0, 100) <= 25):
		target.health -= user.attack;
		ItemUtils.show_activation_toast("Sharpening Stone");
