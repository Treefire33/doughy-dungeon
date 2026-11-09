extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
	if (!(ItemUtils.decision_is_attack(args.decision))): return;
	if (args.user is not Player): return;
	args.target.health += args.user.attack;
	@warning_ignore("integer_division")
	args.target.health -= randi_range(args.user.attack, args.user.max_health / 2);
	ItemUtils.show_activation_toast("Whisk");
