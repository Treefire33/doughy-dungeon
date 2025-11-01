extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (user is not Player): return;
	if (decision != Enum.Decision.Rest): return;
	ItemUtils.show_activation_toast("Pillow");
	user.stamina += 1 * stack_count;