extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
	if (ItemUtils.decision_is_attack(args.decision) || args.spell_specification == Enum.SpellSpecification.Attack): return;
	if (args.user is not Player): return;
	if (randi_range(0, 100) <= 40):
		args.user.health += int(args.user.max_health * 0.4);
		ItemUtils.show_activation_toast("Peace Charm");
