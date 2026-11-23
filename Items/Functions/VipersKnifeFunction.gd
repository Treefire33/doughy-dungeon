extends ItemFunction

func decision(
    args: ItemFunctionArgs
):
    if (args.user is not Player): return;
    if (args.decision != Enum.Decision.Attack): return;
    
    StatusEffect.apply_effect(args.target, 1, Enum.StatusEffect.Poison);
