extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    if (args.user.items.get("DaggerHeart") && !args.user.items.get("LovelyHeart")):
        ItemUtils.show_custom_toast("Your heart is too split to transmute.");
        args.user.coins += 237;
        return;
    
    if (args.user.items.has("LovelyHeart")):
        ItemUtils.show_custom_toast("The Lovely Heart transmutes!");
    
    @warning_ignore("integer_division")
    args.user.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxHealth, (args.user.coins / 10) + 2, "goldenHeartHealth");
    ItemUtils.show_custom_toast("Your heart transmutes...");

func stat_changed(args: ItemFunction.ItemFunctionArgs):
    if (!args.stat_name == "coins"): return;

    @warning_ignore("integer_division")
    args.user.update_stat_mod("goldenHeartHealth", (args.user.coins / 10) + 2);
