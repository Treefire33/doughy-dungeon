extends ItemFunction

func purchased(
    args: ItemFunctionArgs
):
    if (!args.purchased): return;
    args.user.set_persistent_item_value("looseBrickDamage", args.stack_count);

func decision(
    args: ItemFunctionArgs
):
    if (args.user is not Player): return;
    if (!ItemUtils.decision_is_attack(args.decision)): return;

    args.target.health -= 4;
    if (randi_range(0, 100) <= 15):
        ItemUtils.show_custom_toast("The loose brick crumbled...");
        args.user.remove_item("LooseBrick");
    else:
        ItemUtils.show_custom_toast("The loose brick bounced!");
        args.user.set_persistent_item_value("looseBrickDamage", args.user.get_persistent_item_value("looseBrickDamage") + args.stack_count);
