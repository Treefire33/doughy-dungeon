extends RPGEntity

@onready var camera: Camera2D = $Camera;
@onready var animator: AnimationPlayer = $Animator;
@onready var interaction_ray: RayCast2D = $InteractionRay;

@export var rpg_ui: RPGUI;
@export var speed: int = 5;
@export var sprint_mod: int = 2;

func animate_player(movement_direction: Vector2):
    if (movement_direction != Vector2.ZERO && movement_direction == _last_direction): return;
    
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
    if (!object is RPGInteractable): return null;
    return object as RPGInteractable;

func _ready() -> void:
    self._tile_speed = self.speed;
    animator.play("PlayerRPG/ForwardIdle");

func _process(delta: float) -> void:
    if (rpg_ui._in_menu): return;

    var movement_direction: Vector2 = Vector2.ZERO;
    movement_direction = Input.get_vector("Left", "Right", "Up", "Down");
    animate_player(movement_direction);

    if (movement_direction != Vector2.ZERO):
        interaction_ray.target_position = movement_direction * tile_size;
    rpg_ui._current_interactable = get_interactable(interaction_ray);
    
    if (Input.is_action_pressed("Quaternary")):
        self._tile_speed = self.speed + self.sprint_mod;
    else:
        self._tile_speed = self.speed;
    self._tile_velocity = movement_direction;
