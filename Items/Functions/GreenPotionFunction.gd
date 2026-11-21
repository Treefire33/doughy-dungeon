extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
	if (!args.purchased): return;
	ItemUtils.show_activation_toast("Green Potion");
	args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, 2, "greenPotion");
