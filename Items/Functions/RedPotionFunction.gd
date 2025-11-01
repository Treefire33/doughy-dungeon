extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
	if (!purchased): return;
	player.max_health += 1;
	ItemUtils.show_activation_toast("red Potion");
