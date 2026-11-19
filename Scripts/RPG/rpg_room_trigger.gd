extends Area2D
class_name RPGRoomTrigger

@export var entrance_id: int;
@export var entrance_position: Node2D;

@export var next_room_id: StringName;
@export var next_entrance_id: int;

func _ready() -> void:
    self.body_entered.connect(func(body):
        if (next_room_id.is_empty()): return;
        RPGManager.move_rooms(next_room_id, next_entrance_id);
    );
