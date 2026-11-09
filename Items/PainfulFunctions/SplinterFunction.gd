extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is Player || !ItemUtils.decision_is_attack(args.decision)): return;
    if (args.target is not Player): return;
    args.target.health -= args.stack_count;
