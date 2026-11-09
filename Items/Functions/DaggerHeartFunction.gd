extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    if (args.user.items.has("GoldenHeart") && !args.user.items.has("LovelyHeart")):
        ItemUtils.show_custom_toast("Your heart is too pure to peirce.");
        args.user.coins += 450;
        return;
    
    if (args.user.items.has("LovelyHeart")):
        ItemUtils.show_custom_toast("The Lovely Heart transmutes!");

    args.user.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.MaxHealth, 0.5, "daggerHeartHealth");
    args.user.add_stat_mod(Enum.ModifierType.Multiplicative, Enum.StatType.Attack, 2, "daggerHeartAttack");

    ItemUtils.show_activation_toast("Dagger Heart");
