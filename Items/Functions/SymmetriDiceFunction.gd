extends ItemFunction

func purchased(
    args: ItemFunctionArgs
):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 0, "symmetriRerolls");

func stat_changed(
    args: ItemFunctionArgs
):
    if (args.user is not Player || args.stat_name != &"coins"): return;
    args.user.update_stat_mod("symmetriRerolls", args.stat_current / 50);
