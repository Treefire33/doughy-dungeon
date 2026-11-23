extends Resource
class_name ItemFunction

func decision(
    args: ItemFunctionArgs
): pass;

func room_decision(
    args: ItemFunctionArgs
): pass;

func purchased(
    args: ItemFunctionArgs
): pass;

func enemy_kill(
    args: ItemFunctionArgs
): pass;

func stat_changed(
    args: ItemFunctionArgs
): pass;

func removed(
    args: ItemFunctionArgs
): pass;

class ItemFunctionArgs:
    # Doubles as the 'player' argument.
    var user: Entity;
    var target: Entity;
    var room_manager: RoomManager;

    var decision: Enum.Decision;
    var room_decision: Enum.RoomDecision;
    var stack_count: int;
    var purchased: bool;
    var stat_name: StringName;
    var stat_previous: float;
    var stat_current: float;

    var spell_specification: Enum.SpellSpecification;
    var spell_name: StringName;

    static func new_decision_args(
        user: Entity, target: Entity, decision: Enum.Decision, 

        spell_spec: Enum.SpellSpecification = Enum.SpellSpecification.None, 
        spell_name: StringName = &"SPELL_NONE"
    ) -> ItemFunctionArgs:
        var args = ItemFunctionArgs.new();
        args.user = user;
        args.target = target;
        args.decision = decision;
        args.spell_specification = spell_spec;
        args.spell_name = spell_name;
        return args;
    
    static func new_room_decision_args(decision: Enum.RoomDecision) -> ItemFunctionArgs:
        var args = ItemFunctionArgs.new();
        args.room_decision = decision;
        return args;

    static func new_purchased_args(player: Player, purchased: bool) -> ItemFunctionArgs:
        var args = ItemFunctionArgs.new();
        args.user = player;
        args.purchased = purchased;
        return args;
    
    static func new_enemy_kill_args(player: Player, enemy: Entity) -> ItemFunctionArgs:
        var args = ItemFunctionArgs.new();
        args.user = player;
        args.target = enemy;
        return args;

    static func new_stat_changed_args(player: Player, stat_name: StringName, stat_prev: float, stat_new: float) -> ItemFunctionArgs:
        var args = ItemFunctionArgs.new();
        args.user = player;
        args.stat_name = stat_name;
        args.stat_previous = stat_prev;
        args.stat_current = stat_new;
        return args;
