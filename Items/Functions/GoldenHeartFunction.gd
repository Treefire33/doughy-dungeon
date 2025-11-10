extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
    if (!purchased): return;
    player.max_health = (player.coins / 10) + 2;
    ItemUtils.show_custom_toast("Your heart transmutes...");

func stat_changed(player: Player, stat_name: String, stack_count: int):
    if (!stat_name == "coins"): return;

    player.max_health = (player.coins / 10) + 2;
