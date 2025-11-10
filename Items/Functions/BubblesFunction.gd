extends ItemFunction

func force_set_defense(player: Player):
    player.max_defending_duration = 999;
    player.max_defense_durability = 1;

func purchased(player: Player, purchased: bool, stack_count: int):
    force_set_defense(player);

func enemy_kill(player: Player, enemy: Enemy, stack_count: int):
    force_set_defense(player);

func stat_changed(player: Player, stat_name: String, stack_count: int):
    force_set_defense(player);
