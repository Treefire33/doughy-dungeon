extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (decision != Enum.Decision.Attack): return;
	if (user is not Player): return;
	target.health += user.attack;
	target.health -= randi_range(user.attack, user.max_health / 2);
	ItemUtils.show_activation_toast("Whisk");
