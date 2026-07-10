extends Node2D
class_name RPGScene

@export var scene_id: int = 0;

func _enter_tree() -> void:
    GlobalPlayer.current_scene = self.scene_id;
