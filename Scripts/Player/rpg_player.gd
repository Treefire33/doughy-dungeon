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
@onready var raycast: RayCast2D = $UpCast;
@onready var raycast2: RayCast2D = $SideCast;
@onready var raycastDebug: Line2D = $UpCastView;
@onready var raycast2Debug: Line2D = $SideCastView;

@export var interaction_prompt: Panel;
@export var speed: float = 0.1;
@export var run_modifier: float = 1.5;
@export var tile_size: Vector2 = Vector2(32, 32);

var move_direction: Vector2 = Vector2.ZERO;
var last_movement_direction: Vector2;
var current_tween: Tween;
var current_interactable: RPGInteractable;

var currently_moving: bool = false;
func move_player(move_direction: Vector2):
	if (currently_moving || move_direction == Vector2.ZERO):
		return;
	currently_moving = true;
	current_tween = get_tree().create_tween();
	var final_position = position + (move_direction * tile_size);
	current_tween.tween_property(self, "position", final_position, speed);
	current_tween.tween_callback(func():
		currently_moving = false;
	)

func animate_player(direction: Vector2):
	if (direction == last_movement_direction):
		return;
	match (direction):
		Vector2.ZERO:
			animator.play(animator.current_animation.left(-4)+"Idle");
		Vector2(0, -1):
			animator.play("PlayerRPG/BackwardWalk");
		Vector2(0, 1):
			animator.play("PlayerRPG/ForwardWalk");
		Vector2(-1, 0):
			animator.play("PlayerRPG/LeftWalk");
		Vector2(1, 0):
			animator.play("PlayerRPG/RightWalk");
			
func _ready() -> void:
	animator.play("PlayerRPG/ForwardIdle");

func show_interaction_prompt(object: Object):
	if (object is TileMapLayer): return;
	if (object.get_parent() is not RPGInteractable): return;
	object = object.get_parent();
	current_interactable = object;
	interaction_prompt.show();
	interaction_prompt.position = object.position - Vector2(interaction_prompt.size.x / 2, interaction_prompt.size.y + 32);
	interaction_prompt.prompt(current_interactable);

var raycast_changed: bool = false;
func _physics_process(delta: float) -> void:
	move_direction = Vector2.ZERO;

	if (Input.is_action_pressed("Up")):
		move_direction.y += -1;
	if (Input.is_action_pressed("Down")):
		move_direction.y += 1;
	if (Input.is_action_pressed("Left")):
		move_direction.x += -1;
	if (Input.is_action_pressed("Right")):
		move_direction.x += 1;

	if (move_direction.y != 0):
		if (raycast.target_position != Vector2(0, move_direction.y * 32)):
			raycast_changed = true;
		raycast.target_position = Vector2(0, move_direction.y * 32);
	if (move_direction.x != 0):
		if (raycast2.target_position != Vector2(move_direction.x * 32, 0)):
			raycast_changed = true;
		raycast2.target_position = Vector2(move_direction.x * 32, 0);

	if (raycast_changed):
		raycast_changed = false;
		return;
	
	interaction_prompt.hide();
	current_interactable = null;

	raycastDebug.points[1] = raycast.target_position;
	raycast2Debug.points[1] = raycast2.target_position;

	if (raycast.is_colliding()):
		move_direction.y = 0;
		show_interaction_prompt(raycast.get_collider());
	if (raycast2.is_colliding()):
		move_direction.x = 0;
		show_interaction_prompt(raycast2.get_collider());
	animate_player(move_direction);
	last_movement_direction = move_direction;
	move_player(move_direction);

func _input(event: InputEvent) -> void:
	if (current_interactable == null): return;
	if (Input.is_action_just_pressed("Primary")):
		if (current_interactable.opens_dungeon):
			GlobalPlayer.current_dungeon = current_interactable.dungeon;
			var tween = get_tree().create_tween();
			tween.tween_property(get_parent(), "modulate", Color(0, 0, 0, 1), 0.8);
			await tween.finished;
			get_tree().change_scene_to_file("res://Scenes/game.tscn");
