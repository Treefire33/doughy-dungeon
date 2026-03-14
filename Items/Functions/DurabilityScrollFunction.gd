extends ItemFunction

func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (!purchased): return;
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxDurability, 1);

    ItemUtils.show_activation_toast("Durability Scroll");
