extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (user is not Player): return;
	ItemUtils.show_activation_toast("Coffee");
	user.stamina = user.max_stamina;
