extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (!purchased): return;
    player.coins += randi_range(-100, 100);
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, -1);
    ItemUtils.show_activation_toast("Fragment");
    GlobalPlayer.increment_flag(&"iAbyssFragmentCount");
    if (GlobalPlayer.abyss_fragment_count == 9):
        ItemUtils.show_custom_toast("The fragments have merged.");
        MidnightDebug.remove_item("AbyssFragment", player.items["AbyssFragment"]);
        MidnightDebug.add_item("AbyssHeart");
        GlobalPlayer.set_flag(&"iAbyssFragmentCount", 0);
        GlobalPlayer.set_bool_flag(&"bAbyssHeartObtained", true);
