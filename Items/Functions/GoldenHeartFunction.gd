extends ItemFunction

func purchased(player: Player, purchased: bool, _room_manager: RoomManager, _stack_count: int):
    if (!purchased): return;
    if (player.items.get("DaggerHeart")):
        ItemUtils.show_custom_toast("The dagger shatters...");
        player.remove_stat_mod("daggerHeartHealth", true);
        player.remove_stat_mod("daggerHeartAttack", true);
        player.items.erase("DaggerHeart");
    
    @warning_ignore("integer_division")
    player.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxHealth, (player.coins / 10) + 2, "goldenHeartHealth");
    ItemUtils.show_custom_toast("Your heart transmutes...");

func stat_changed(player: Player, stat_name: String, _room_manager: RoomManager, _stack_count: int):
    if (!stat_name == "coins"): return;

    @warning_ignore("integer_division")
    player.update_stat_mod("goldenHeartHealth", (player.coins / 10) + 2);
