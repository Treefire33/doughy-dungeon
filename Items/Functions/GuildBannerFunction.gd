extends ItemFunction

# (1, 2, 3) -> (3, 2, 1)
# Health, Stamina, Attack -> Attack, Stamina, Health
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (purchased):
        ItemUtils.show_custom_toast("The banner sets you in line with your priorities...");
        player.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.MaxHealth, player._attack, "guildBannerHealth");
        player.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.Attack, player._max_health, "guildBannerAttack");

    player.update_stat_mod("guildBannerHealth", player._attack);
    player.update_stat_mod("guildBannerAttack", player._max_health);

func stat_changed(
    player: Player, stat_name: String,
    room_manager: RoomManager, stack_count: int
):
    player.update_stat_mod("guildBannerHealth", player._attack);
    player.update_stat_mod("guildBannerAttack", player._max_health);
