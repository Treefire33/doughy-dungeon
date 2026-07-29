extends Node2D
class_name RPGScene

@export var scene_id: StringName = "";

func _enter_tree() -> void:
    RPGEventBus.clear_connections();

func _ready() -> void:
    GlobalPlayer.current_scene = self.scene_id;
    Audio.play_music(Audio.overworld_music);
    RPGEventBus.fire_event(RPGEventBus.RPGRoomEventArgs.new(RPGEventBus.RPGEventId.RPG_RoomEntered, self.scene_id));

func _exit_tree() -> void:
    RPGEventBus.fire_event(RPGEventBus.RPGRoomEventArgs.new(RPGEventBus.RPGEventId.RPG_RoomExited, self.scene_id));
