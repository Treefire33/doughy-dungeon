extends ItemFunction

func purchased(
    player: Player, purchased: bool, 
    room_manager: RoomManager, stack_count: int
):
    player.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.Attack, 5, "hollowKnight");
    ItemUtils.show_activation_toast("Nail");

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player): return;
    if (!ItemUtils.decision_is_attack(decision)): return;

    if (target.defense_durability > 0):
        ItemUtils.show_custom_toast("Shield break!");
        target.defense_durability = 0;
        target.health -= user.attack;
