extends ItemFunction

func purchased(
    args: ItemFunctionArgs
):
    if (args.user is not Player || !args.purchased): return;
    if (args.user.has_stat_mod("diceReroll")):
        args.user.update_stat_mod("diceRerolls", args.stack_count);
    else:
        args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Rerolls, 1, "diceRerolls");
    
    args.user.rerolls += 1;

func removed(
    args: ItemFunctionArgs
):
    pass;
