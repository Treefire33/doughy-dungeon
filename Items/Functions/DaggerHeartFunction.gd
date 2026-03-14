extends ItemFunction

func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (!purchased): return;
    if (player.items.get("GoldenHeart")):
        ItemUtils.show_custom_toast("Your heart is too pure to puncture.");
        player.coins += 450;
        return;

    player.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.MaxHealth, 0.5, "daggerHeartHealth");
    player.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.Attack, 2, "daggerHeartAttack");

    ItemUtils.show_activation_toast("Dagger Heart");
