extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.decision != Enum.Decision.Rest): return;
    if (args.user is not Player): return;

    args.user.health += 1 * args.stack_count;
