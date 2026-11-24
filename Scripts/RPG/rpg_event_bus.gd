extends Node

signal event_fired(args: RPGEventArgs);

signal rpg_interaction_signal(args: RPGEventArgs);
signal rpg_enter_dungeon_signal(args: RPGEventArgs);
signal rpg_inspect_dungeon_signal(args: RPGEventArgs);
signal rpg_dialogue_signal(args: RPGEventArgs);
signal rpg_room_entered_signal(args: RPGEventArgs);
signal rpg_room_exited_signal(args: RPGEventArgs);

func fire_event(args: RPGEventArgs):
    self.event_fired.emit(args);

func _id_specific_connection(args: RPGEventArgs):
    var signal_name: StringName = StringName("rpg_%s_signal" % _id_to_signal_name[args.event_id]);
    emit_signal(signal_name, args);

var _id_to_signal_name: Dictionary[RPGEventId, String] = {
    RPGEventId.RPG_Interaction: "interaction",
    RPGEventId.RPG_EnterDungeon: "enter_dungeon",
    RPGEventId.RPG_InpsectDungeon: "inspect_dungeon",
    RPGEventId.RPG_Dialogue: "dialogue",
    RPGEventId.RPG_RoomEntered: "room_entered",
    RPGEventId.RPG_RoomExited: "room_exited"
};
func connect_to_id(event_id: RPGEventId, callable: Callable):
    var signal_name: StringName = StringName("rpg_%s_signal" % _id_to_signal_name[event_id]);
    connect(signal_name, callable);

func clear_connections():
    pass;

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

class RPGDialogueArgs extends RPGInteractionArgs:
    var dialogue: DialogueResource;

    func _init(event_id: RPGEventId, interaction_object: RPGInteractable, dialogue: DialogueResource) -> void:
        super(event_id, interaction_object);
        self.dialogue = dialogue;
