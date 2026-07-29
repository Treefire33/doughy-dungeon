extends Node

signal event_fired(args: RPGEventArgs);

func fire_event(args: RPGEventArgs):
    self.event_fired.emit(args);

var _id_specific_connections: Dictionary[RPGEventId, Array] = {};
func _id_specific_connection(args: RPGEventArgs):
    if (!_id_specific_connections.get(args.event_id)): return;
    for callable in _id_specific_connections[args.event_id]:
        if (!callable.is_valid()):
            _id_specific_connections[args.event_id].erase(callable);
            continue;
        callable.call(args);

func connect_to_id(event_id: RPGEventId, callable: Callable):
    if (!_id_specific_connections.get(event_id)): _id_specific_connections[event_id] = [];
    _id_specific_connections[event_id].append(callable);

func clear_connections():
    _id_specific_connections.clear();

func _ready() -> void:
    self.event_fired.connect(_id_specific_connection);

# Event Ids
enum RPGEventId {
    RPG_Interaction,
    RPG_EnterDungeon,
    RPG_InpsectDungeon,
    RPG_Dialogue,

    RPG_RoomEntered,
    RPG_RoomExited,
}

class RPGEventArgs extends RefCounted:
    var event_id: RPGEventId;

    func _init(event_id: RPGEventId) -> void:
        self.event_id = event_id;

class RPGRoomEventArgs extends RPGEventArgs:
    var scene_id: StringName;

    func _init(event_id: RPGEventId, scene_id: StringName) -> void:
        super(event_id);
        self.scene_id = scene_id;

class RPGInteractionArgs extends RPGEventArgs:
    var interaction_object: RPGInteractable;

    func _init(event_id: RPGEventId, interaction_object: RPGInteractable) -> void:
        super(event_id);
        self.interaction_object = interaction_object;
