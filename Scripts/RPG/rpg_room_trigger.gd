extends Area2D
class_name RPGRoomTrigger

@export var trigger_room: String;

func _ready() -> void:
    self.body_entered.connect(func(body):
        SuperLoader.switch_scene(trigger_room);
    );
