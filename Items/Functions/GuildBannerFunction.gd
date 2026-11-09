extends ItemFunction

# (1, 2, 3) -> (3, 2, 1)
# Health, Stamina, Attack -> Attack, Stamina, Health
func purchased(args: ItemFunction.ItemFunctionArgs):
    if (args.purchased):
        ItemUtils.show_custom_toast("The banner sets you in line with your priorities...");
        args.user.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.MaxHealth, args.user._attack, "guildBannerHealth");
        args.user.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.Attack, args.user._max_health, "guildBannerAttack");

    args.user.update_stat_mod("guildBannerHealth", args.user._attack);
    args.user.update_stat_mod("guildBannerAttack", args.user._max_health);

func stat_changed(args: ItemFunction.ItemFunctionArgs):
    args.user.update_stat_mod("guildBannerHealth", args.user._attack);
    args.user.update_stat_mod("guildBannerAttack", args.user._max_health);
