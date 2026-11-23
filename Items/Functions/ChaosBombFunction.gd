extends ItemFunction

var stacking_damage: int = 0;
func decision(
    args: ItemFunctionArgs
):
    if (args.user is not Player): return;
    if (args.decision != Enum.Decision.Spell): return;
    if (args.spell_specification != Enum.SpellSpecification.Activate): return;

    args.user.health -= 1 + stacking_damage;
    stacking_damage += 1 * args.stack_count;
