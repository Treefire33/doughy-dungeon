extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player || args.decision != Enum.Decision.Rest): return;
    args.user.defending_duration -= 1;
