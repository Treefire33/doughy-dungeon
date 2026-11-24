extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;

    var factor: float = (args.stack_count * 4);
    if (!args.user.has_stat_mod("bubbleDurationMod")):
        args.user.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.MaxDuration, factor, "bubbleDurationMod");
        args.user.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.MaxDurability, 1 / factor, "bubbleDurabilityMod");
    else:
        args.user.update_stat_mod("bubbleDurationMod", factor);
        args.user.update_stat_mod("bubbleDurabilityMod", 1 / factor);
