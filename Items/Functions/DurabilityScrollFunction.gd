extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
    if (!purchased): return;
    player.max_defense_durability += 1;

    ItemUtils.show_activation_toast("Durability Scroll");
