extends Resource
class_name ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int): pass;
func room_decision(room_manager: RoomManager, decision: Enum.RoomDecision, stack_count: int): pass;
func purchased(player: Player, purchased: bool, stack_count: int): pass;
func enemy_kill(player: Player, enemy: Enemy, stack_count: int): pass;
func stat_changed(player: Player, stat_name: String, stack_count: int): pass;