extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (randi_range(0, 100) < 10):
        args.user.health += (int)(args.user.max_health * 0.5);
        ItemUtils.show_activation_toast("Graffiti Heart");
