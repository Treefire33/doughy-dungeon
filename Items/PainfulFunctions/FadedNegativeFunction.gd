extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player || !ItemUtils.decision_is_attack(args.decision)): return;
    if (randf_range(0, 100) > 15 * (args.stack_count / 3.0)): return;
    args.user.health -= args.user.attack;
