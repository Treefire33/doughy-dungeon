extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
	if (!args.purchased): return;
	ItemUtils.show_activation_toast("Blue Potion");
	args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxDuration, 1, "bluePotion");
