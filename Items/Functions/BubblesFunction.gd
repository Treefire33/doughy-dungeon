extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxDuration, 50, "bubbleDurationMod");
    args.user.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxDurability, 1, "bubbleDurabilityMod");
