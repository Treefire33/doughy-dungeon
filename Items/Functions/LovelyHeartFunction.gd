extends ItemFunction

func get_heart_count(player: Player) -> int:
    var count: int = 0;
    for item: String in player.items:
        if (!item.to_lower().contains("heart")): continue;
        count += player.items[item];
    return max(1, count);

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased):
        args.user.update_stat_mod("lovelyHeartAttack", get_heart_count(args.user));
        return;
    
    @warning_ignore("integer_division")
    args.user.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.Attack, get_heart_count(args.user), "lovelyHeartAttack");
    ItemUtils.show_custom_toast("You begin to wield your love...");

