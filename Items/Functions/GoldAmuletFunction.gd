extends ItemFunction

func enemy_kill(args: ItemFunction.ItemFunctionArgs):
    args.target.coin_drop_range = [args.target.coin_drop_range[0] + 5, args.target.coin_drop_range[1] + 10];
    ItemUtils.show_activation_toast("Gold Amulet");
