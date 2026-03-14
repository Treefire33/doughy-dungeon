extends Resource
class_name ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
): pass;

func room_decision(
    decision: Enum.RoomDecision, 
    room_manager: RoomManager, stack_count: int
): pass;

func purchased(
    player: Player, purchased: bool, 
    room_manager: RoomManager, stack_count: int
): pass;

func enemy_kill(
    player: Player, enemy: Enemy, 
    room_manager: RoomManager, stack_count: int
): pass;

func stat_changed(
    player: Player, stat_name: String,
    room_manager: RoomManager, stack_count: int
): pass;