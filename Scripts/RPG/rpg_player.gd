extends Node2D

@onready var camera: Camera2D = $Camera;
@onready var animator: AnimationPlayer = $Animator;
@onready var vertical_raycast: RayCast2D = $UpCast;
@onready var horizontal_raycast: RayCast2D = $SideCast;
@onready var omni_raycast: RayCast2D = $OmniCast;

# RPG UI
@onready var dungeon_inspect: Panel = $Camera/UI/Inspect;
@onready var dungeon_name: Label = $Camera/UI/Inspect/DungeonInspect/Name;
@onready var dungeon_description: Label = $Camera/UI/Inspect/DungeonInspect/Description;
@onready var static_prompt_dungeon: Label = $Camera/UI/Inspect/DungeonInspect/StaticPrompt;
@onready var dialogue_box: DialogueBox = $Camera/UI/DialogueBox;

@export var speed: float = 0.1;
@export var sprint_speed: float = 0.075;
@export var tile_size: Vector2 = Vector2(32, 32);
@export var interaction_prompt: Panel;

var last_direction: Vector2;
var current_move_tween: Tween;
var current_interactable: RPGInteractable;

func move_player(movement_direction: Vector2):
	if (current_move_tween && current_move_tween.is_running()):
		return;
	if (movement_direction == Vector2.ZERO):
		return;
	current_move_tween = get_tree().create_tween();
	var final_position = self.position + (movement_direction * tile_size);
	current_move_tween.tween_property(self, "position", final_position, speed);

func animate_player(movement_direction: Vector2):
	if (movement_direction != Vector2.ZERO && movement_direction == last_direction): return;
	
	match (movement_direction):
		Vector2.ZERO:
			animator.play(animator.current_animation.left(-4)+"Idle");
		Vector2.UP:
			animator.play("PlayerRPG/BackwardWalk");
		Vector2.DOWN:
			animator.play("PlayerRPG/ForwardWalk");
		Vector2.LEFT:
			animator.play("PlayerRPG/LeftWalk");
		Vector2.RIGHT:
			animator.play("PlayerRPG/RightWalk");

func get_interactable(raycast: RayCast2D) -> RPGInteractable:
	if (!raycast.get_collider()): return null;
	var object = raycast.get_collider();
	if (object is TileMapLayer): return null;
	if (!object.get_parent() is RPGInteractable): return null;
	object = object.get_parent();
	return object as RPGInteractable;

func check_collision(movement_direction: Vector2):
	var final_direction = Vector2.ZERO;
	current_interactable = null;
	if (horizontal_raycast.is_colliding()):
		final_direction.x -= -movement_direction.x;
		current_interactable = get_interactable(horizontal_raycast);
	if (vertical_raycast.is_colliding()):
		final_direction.y -= -movement_direction.y;
		current_interactable = get_interactable(vertical_raycast);
	if (omni_raycast.is_colliding()):
		final_direction -= -movement_direction;
	return final_direction;

func show_prompt():
	interaction_prompt.show();
	interaction_prompt.position = current_interactable.position - interaction_prompt.size / 2;

func rpg_interact():
	if (current_interactable is RPGDungeon):
		if (dungeon_inspect.visible):
			GlobalPlayer.current_dungeon = current_interactable.dungeon;
			var tween = get_tree().create_tween();
			tween.tween_property(get_parent(), "modulate", Color(0, 0, 0, 1), 0.8);
			await tween.finished;
			get_tree().change_scene_to_file("res://Scenes/game.tscn");
			return;
		dungeon_inspect.show();
		dungeon_name.text = current_interactable.dungeon.name;
		dungeon_description.text = current_interactable.dungeon.description;
		return;

func _ready() -> void:
	animator.play("PlayerRPG/ForwardIdle");
	static_prompt_dungeon.text = Keybinds.format_action_string(static_prompt_dungeon.text);

func _physics_process(delta: float) -> void:
	var movement_direction: Vector2 = Vector2.ZERO;
	movement_direction = Input.get_vector("Left", "Right", "Up", "Down");

	animate_player(movement_direction);

	if (movement_direction.y != 0):
		vertical_raycast.target_position.y = movement_direction.y * tile_size.y;
	if (movement_direction.x != 0):
		horizontal_raycast.target_position.x = movement_direction.x * tile_size.y;

	omni_raycast.target_position = movement_direction;

	movement_direction -= check_collision(movement_direction);

	if (current_interactable != null):
		show_prompt();
	else:
		interaction_prompt.hide();

	move_player(movement_direction);
	last_direction = movement_direction;

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Primary")):
		if (current_interactable == null): return;
		rpg_interact();
	
	if (Input.is_action_just_pressed("Secondary")):
		if (dungeon_inspect.visible):
			dungeon_inspect.hide();
