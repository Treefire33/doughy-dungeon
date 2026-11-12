extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player || !ItemUtils.decision_is_spell(args.decision)): return;

    args.user.stamina += 1 * args.stack_count;
