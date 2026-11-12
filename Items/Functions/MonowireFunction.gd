extends ItemFunction

func purchased(
    args: ItemFunctionArgs
):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.Attack, 0.35, "cyberMonowireMod");

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (!ItemUtils.decision_is_attack(args.decision)): return;
    if ((args.target.defending_duration <= 0 || args.target.defense_durability <= 0) && !args.target.defense_stun):
        args.target.health += args.user.attack;
    for enemy in args.room_manager.get_alive_enemies():
        if (enemy == null):
            continue;
        enemy.health -= args.user.attack;
