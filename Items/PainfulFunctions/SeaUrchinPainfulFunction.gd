extends ItemFunction

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;
    if (args.target is not Player): return;
    var sharp_count = args.target.items.get("SharpeningStone", 0);
    var bubble_count = args.target.items.get("Bubbles", 0);
    var coral_count = args.target.items.get("CoralTubes", 0);
    var abyss_count = args.target.items.get("AbyssFragment", 0) + args.target.items.get("AbyssHeart", 0);
    if (sharp_count > 0): 
        if (randi_range(0, 100) < sharp_count * 5):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to the Sharpening Stone!");
            args.target.health -= args.user.attack;
    if (bubble_count > 0):
        if (randi_range(0, 100) < bubble_count * 2):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to your Bubbles!");
            args.user.defending_duration = args.user.max_defending_duration;
    if (coral_count > 0):
        if (randi_range(0, 100) < coral_count * 4):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to the Organ Coral!");
            args.target.health -= coral_count;
    if (abyss_count > 0):
        if (randi_range(0, 1000) > 1): return;
        ItemUtils.show_custom_toast("The (painful) Urchin falls to abyss.");
        args.target.items.erase("SeaUrchin");
        args.target.add_item("AbyssFragment");
