extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.Attack, 5, "hollowKnight");
    ItemUtils.show_activation_toast("Nail");

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (!ItemUtils.decision_is_attack(args.decision)): return;

    if (args.target.defense_durability > 0):
        ItemUtils.show_custom_toast("Shield break!");
        args.target.defense_durability = 0;
        args.target.health -= args.user.attack;
