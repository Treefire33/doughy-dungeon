extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is Player): return;
    if (args.target is not Player): return;
    args.target = args.target as Player;
    var sharp_count = args.target.items.get("SharpeningStone", 0);
    var bubble_count = args.target.items.get("Bubbles", 0);
    var coral_count = args.target.items.get("CoralTubes", 0);
    var abyss_count = args.target.items.get("AbyssFragment", 0) + args.target.items.get("AbyssHeart", 0);
    if (sharp_count > 0): 
        if (randi_range(0, 100) < sharp_count * 5):
            ItemUtils.show_custom_toast("The Urchin reacted to the Sharpening Stone!");
            args.user.health -= args.user.attack;
    if (bubble_count > 0):
        if (randi_range(0, 100) < bubble_count * 2):
            ItemUtils.show_custom_toast("The Urchin reacted to your Bubbles!");
            args.target.defending_duration = args.target.max_defending_duration - 25;
    if (coral_count > 0):
        if (randi_range(0, 100) < coral_count * 4):
            ItemUtils.show_custom_toast("The Urchin reacted to the Organ Coral!");
            args.user.health -= coral_count;
    if (abyss_count > 0):
        if (randi_range(0, 1000) > 1): return;
        ItemUtils.show_custom_toast("The Urchin fragments from the abyss.");
        args.target.items.erase("SeaUrchin");
        args.target.add_item("AbyssFragment");
