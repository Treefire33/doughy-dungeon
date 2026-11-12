extends ItemFunction

func set_saved_values(user: Entity):
    user.set_persistent_item_value("clockhand_health", user.health);
    user.set_persistent_item_value("clockhand_stamina", user.stamina);
    user.set_persistent_item_value("clockhand_defending_duration", user.defending_duration);
    user.set_persistent_item_value("clockhand_defense_durability", user.defense_durability);

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    set_saved_values(args.user);

var turn_count: int = 0;
func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;

    if (args.spell_specification == Enum.SpellSpecification.Activate):
        ItemUtils.show_custom_toast("The clock rewinds...");
        args.user.health = args.user.get_persistent_item_value("clockhand_health");
        args.user.stamina = args.user.get_persistent_item_value("clockhand_stamina");
        args.user.defending_duration = args.user.get_persistent_item_value("clockhand_defending_duration");
        args.user.defense_durability = args.user.get_persistent_item_value("clockhand_defense_durability");
        return;

    if (turn_count >= 2):
        turn_count = 0;
        ItemUtils.show_custom_toast("The clock jumps forward, resetting.");
        set_saved_values(args.user);
    else:
        turn_count += 1;
