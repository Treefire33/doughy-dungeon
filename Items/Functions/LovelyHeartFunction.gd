extends ItemFunction

func get_heart_count(player: Player) -> int:
    var count: int = 0;
    for item: String in player.items:
        if (!item.to_lower().contains("heart")): continue;
        count += player.items[item];
    return max(1, count);

func purchased(player: Player, purchased: bool, _room_manager: RoomManager, _stack_count: int):
    if (!purchased):
        player.update_stat_mod("lovelyHeartAttack", get_heart_count(player));
        return;
    
    @warning_ignore("integer_division")
    player.add_stat_mod(Enum.ModifierType.Preset, Enum.StatType.Attack, get_heart_count(player), "lovelyHeartAttack");
    ItemUtils.show_custom_toast("You begin to wield your love...");

