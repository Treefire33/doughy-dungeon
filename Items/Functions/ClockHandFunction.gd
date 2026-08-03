extends ItemFunction

var last_health: int = 0;
var last_stamina: int = 0;
var last_attack: int = 0;
var last_defending_duration: int = 0;
var last_defense_durability: int = 0;

var turn_count: int = 0;

func purchased(
    player: Player, purchased: bool, 
    room_manager: RoomManager, stack_count: int
):
    if (!purchased): return;
    last_health = player.health;
    last_stamina = player.stamina;
    last_defending_duration = player.defending_duration;
    last_defense_durability = player.defense_durability;

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player): return;

    if (decision == Enum.Decision.SpellRetype):
        user.health = last_health;
        user.stamina = last_stamina;
        user.defending_duration = last_defending_duration;
        user.defense_durability = last_defense_durability;
        return;

    if (turn_count >= 2):
        turn_count = 0;
        last_health = user.health;
        last_stamina = user.stamina;
        last_defending_duration = user.defending_duration;
        last_defense_durability = user.defense_durability;
    else:
        turn_count += 1;
