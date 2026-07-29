extends RPGEntity
class_name RPGInteractable

func _ready() -> void:
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_Interaction, _on_interaction);
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_RoomEntered, _on_room_entered);
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_RoomExited, _on_room_exited);

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    pass;

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    pass;

func _on_room_exited(args: RPGEventBus.RPGRoomEventArgs):
    pass;
