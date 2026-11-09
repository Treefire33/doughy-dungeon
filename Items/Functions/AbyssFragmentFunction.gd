extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    args.user.coins += randi_range(-100, 100);
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, -1);
    ItemUtils.show_custom_toast("...");
    GlobalPlayer.increment_flag(&"iAbyssFragmentCount");
    if (GlobalPlayer.get_flag(&"iAbyssFragmentCount") == 9):
        ItemUtils.show_custom_toast("The Abyss fragments hastily merge.");
        MidnightDebug.remove_item("AbyssFragment", args.user.items["AbyssFragment"]);
        MidnightDebug.add_item("AbyssHeart");
        GlobalPlayer.set_flag(&"iAbyssFragmentCount", 0);
        GlobalPlayer.set_bool_flag(&"bAbyssHeartObtained", true);
