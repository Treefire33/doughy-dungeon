extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
    if (!purchased): return;
    player.max_health /= 2;
    player.attack *= 2;

    ItemUtils.show_activation_toast("Dagger Heart");
