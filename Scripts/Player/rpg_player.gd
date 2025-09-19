extends Node2D
class_name RPGPlayer

enum Direction {
	Up,
	Down,
	Left,
	Right
}

@onready var camera: Camera2D = $Camera;
@onready var sprite: Sprite2D = $Sprite;
@onready var animator: AnimationPlayer = $Animator;

@export var speed: float = 0.1;
@export var run_modifier: int = 1;
@export var tile_size: Vector2 = Vector2(32, 32);

var move_direction: Vector2 = Vector2(0, 0);
var currently_moving: bool = false;

func move_player():
	if (currently_moving):
		return;
	currently_moving = true;
	var move_tween = get_tree().create_tween();
	var final_position = position + (move_direction * tile_size);
	move_tween.tween_property(self, "position", final_position, speed);
	move_tween.tween_callback(func():
		currently_moving = false;
	)

func animate_player(direction: int):
	sprite.flip_h = false;
	match (direction):
		0:
			animator.play("PlayerRPG/ForwardWalk");
		1:
			animator.play("PlayerRPG/BackwardWalk");
		2:
			animator.play("PlayerRPG/SidewaysWalk");
		3:
			sprite.flip_h = true;
			animator.play("PlayerRPG/SidewaysWalk");

func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_W)):
		move_direction.y += -1;
		animate_player(0);
	if (Input.is_key_pressed(KEY_S)):
		move_direction.y += 1;
		animate_player(1);
	if (Input.is_key_pressed(KEY_A)):
		move_direction.x += -1;
		animate_player(2);
	if (Input.is_key_pressed(KEY_D)):
		move_direction.x += 1;
		animate_player(3);
	move_player();
