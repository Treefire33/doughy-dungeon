extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
	if (!args.purchased): return;
	args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, 2);
	ItemUtils.show_activation_toast("Red Potion");
