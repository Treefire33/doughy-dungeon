extends ItemFunction

var cummulative_damage: float = 0;
func purchased(
    args: ItemFunctionArgs
):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 0, "brokenHeartMod");

func stat_changed(
    args: ItemFunctionArgs
):
    if (args.user is not Player): return;
    if (args.stat_name != &"health"): return;
    var damage_taken: float = args.stat_current - args.stat_previous;
    cummulative_damage += damage_taken;
    args.user.update_stat_mod("brokenHeartMod", cummulative_damage / 10);
