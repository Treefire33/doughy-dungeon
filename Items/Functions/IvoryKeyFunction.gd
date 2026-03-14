extends ItemFunction

var attack: int = 0;
var stamina: int = 0;
var defense: int = 0;

func purchased(
    player: Player, purchased: bool, 
    room_manager: RoomManager, stack_count: int
):
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, attack, "ivoryAttack");
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, stamina, "ivoryStamina");
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxDuration, defense, "ivoryDefense");

    ItemUtils.show_custom_toast("Do Re Mi Fa Sol La Ti Do!");

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player): return;

    match (decision):
        Enum.Decision.Attack:
            attack += 1;
            user.update_stat_mod("ivoryAttack", attack);
            ItemUtils.show_custom_toast("The key ressonates at an A.");
        Enum.Decision.Defend:
            defense += 1;
            user.update_stat_mod("ivoryDefense", defense);
            ItemUtils.show_custom_toast("The key ressonates at a D.");
        Enum.Decision.Rest:
            stamina += 1;
            user.update_stat_mod("ivoryStamina", stamina);
            ItemUtils.show_custom_toast("The key ressonates at an E.");

func room_decision(
    decision: Enum.RoomDecision, 
    room_manager: RoomManager, stack_count: int
):
    ItemUtils.show_custom_toast("The key goes dead.");
    attack = 0; defense = 0; stamina = 0;
    room_manager.player.update_stat_mod("ivoryAttack", attack);
    room_manager.player.update_stat_mod("ivoryDefense", defense);
    room_manager.player.update_stat_mod("ivoryStamina", stamina);
