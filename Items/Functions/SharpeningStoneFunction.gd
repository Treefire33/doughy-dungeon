extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
	if (args.target == null): return;
	if (args.user is not Player): return;
	if (!(ItemUtils.decision_is_attack(args.decision))): return;
	if (args.target.defending_duration != 0): return;
	if (randi_range(0, 100) <= 25):
		args.target.health -= args.user.attack;
		ItemUtils.show_activation_toast("Sharpening Stone");
