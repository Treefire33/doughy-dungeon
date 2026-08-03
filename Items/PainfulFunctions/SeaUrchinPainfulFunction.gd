extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, room_manager: RoomManager, stack_count: int):
    if (user is not Player): return;
    if (target is not Player): return;
    target = target as Player;
    var sharp_count = target.items.get("SharpeningStone", 0);
    var bubble_count = target.items.get("Bubbles", 0);
    var coral_count = target.items.get("CoralTubes", 0);
    var abyss_count = target.items.get("AbyssFragment", 0) + target.items.get("AbyssHeart", 0);
    if (sharp_count > 0): 
        if (randi_range(0, 100) < sharp_count * 5):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to the Sharpening Stone!");
            target.health -= user.attack;
    if (bubble_count > 0):
        if (randi_range(0, 100) < bubble_count * 2):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to your Bubbles!");
            user.defending_duration = user.max_defending_duration;
    if (coral_count > 0):
        if (randi_range(0, 100) < coral_count * 4):
            ItemUtils.show_custom_toast("The (painful) Urchin reacted to the Organ Coral!");
            target.health -= coral_count;
    if (abyss_count > 0):
        if (randi_range(0, 1000) > 1): return;
        ItemUtils.show_custom_toast("The (painful) Urchin falls to abyss.");
        target.items.erase("SeaUrchin");
        target.add_item("AbyssFragment");
