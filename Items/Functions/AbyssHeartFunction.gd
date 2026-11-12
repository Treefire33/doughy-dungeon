extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (args.decision != Enum.Decision.Rest): return;
    if (args.user.attack - 1 <= 0): return;
    
    ItemUtils.show_custom_toast("The Abyss Heart weakens you.");
    args.user.remove_stat_mod("abyssAttack");

func room_decision(args: ItemFunction.ItemFunctionArgs):
    if (args.room_manager.player.max_health - 1 > 0):
        args.room_manager.player.remove_stat_mod("abyssHealth");
    args.room_manager.player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, 5, "abyssStamina");

    ItemUtils.show_custom_toast("The Abyss Heart energizes you.");

func enemy_kill(args: ItemFunction.ItemFunctionArgs):
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 1, "abyssAttack");
    ItemUtils.show_custom_toast("The Abyss Heart strengthens you.");

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (args.purchased): return false;
    if (args.user.max_stamina - 5 > 0):
        args.room_manager.player.remove_stat_mod("abyssStamina");
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, 1, "abyssHealth");
    
    ItemUtils.show_custom_toast("The Abyss Heart vitalizes you.");
