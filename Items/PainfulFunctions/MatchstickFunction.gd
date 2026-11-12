extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;

    if (args.spell_specification == Enum.SpellSpecification.Defend && !StatusEffect.has_effect(args.user, Enum.StatusEffect.Burn)):
        StatusEffect.apply_effect(args.user, 1, Enum.StatusEffect.Burn);
