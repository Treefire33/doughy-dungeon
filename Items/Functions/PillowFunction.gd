extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
	if (args.user is not Player): return;
	if (args.decision != Enum.Decision.Rest): return;
	ItemUtils.show_activation_toast("Pillow");
	args.user.stamina += 1 * args.stack_count;