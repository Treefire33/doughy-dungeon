extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (args.decision != Enum.Decision.Attack): return;
    for enemy in args.room_manager.get_alive_enemies():
        if (enemy == args.target || enemy == null):
            continue;
        enemy.health -= roundi((0.25 * args.stack_count) * args.user.attack);
