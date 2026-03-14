extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (!purchased): return;
    player.coins += randi_range(-100, 100);
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, -1);
    ItemUtils.show_activation_toast("Fragment");
    GlobalPlayer.abyss_fragments_collected += 1;
    if (GlobalPlayer.abyss_fragments_collected == 9):
        ItemUtils.show_custom_toast("The fragments have merged.");
        MidnightDebug.remove_item("AbyssFragment", player.items["AbyssFragment"]);
        MidnightDebug.add_item("AbyssHeart");
        GlobalPlayer.abyss_fragments_collected = 0;
        GlobalPlayer.has_abyss_heart = true;
