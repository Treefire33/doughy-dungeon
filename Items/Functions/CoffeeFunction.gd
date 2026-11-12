extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
	if (args.user is not Player): return;
	args.user.stamina = args.user.max_stamina;
	if (randi_range(1, 100) < 5):
		args.user.health -= 1;
