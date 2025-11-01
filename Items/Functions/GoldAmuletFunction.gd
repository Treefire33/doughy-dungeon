extends ItemFunction

func enemy_kill(player: Player, enemy: Enemy, stack_count: int):
    enemy.coin_drop_range = [enemy.coin_drop_range[0] + 5, enemy.coin_drop_range[1] + 10];
    ItemUtils.show_activation_toast("Gold Amulet");
