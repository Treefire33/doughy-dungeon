extends RPGEntity
class_name RPGPlayer

@onready var camera: Camera2D = $Camera;
@onready var animator: AnimationPlayer = $Animator;
@onready var interaction_ray: RayCast2D = $InteractionRay;
@onready var sprite: Sprite2D = $Sprite;

@export var rpg_ui: RPGUI;
@export var speed: int = 5;
@export var sprint_mod: int = 2;

@export var tattered_texture: Texture2D;
@export var guild_texture: Texture2D;

func animate_player():
    var move_axis: Vector2 = Vector2(round(self._tile_velocity.x), round(self._tile_velocity.y));
    if (move_axis != Vector2.ZERO && move_axis == _last_direction): return;
    
    match (move_axis):
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

    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_RoomEntered, func(args: RPGEventBus.RPGRoomEventArgs):
        if (GlobalPlayer.completed_dungeons[Enum.Dungeon.Alcove]):
            GlobalPlayer.add_rpg_item("GuildApp");
            GlobalPlayer.add_rpg_item("BronzeSword");
            GlobalPlayer.add_rpg_item("StandardSpellTwo");
        if (GlobalPlayer.completed_dungeons[Enum.Dungeon.Oceanic]):
            GlobalPlayer.unlocked_items.append("GuildMember");
        if (GlobalPlayer.completed_dungeons[Enum.Dungeon.ErrorEntity]):
            GlobalPlayer.unlocked_items.append("ErroneousCloak");
    );

func _draw() -> void:
    if (GlobalPlayer.cloak.name != "Tattered Cloak"):
        sprite.texture = guild_texture;
    else:
        sprite.texture = tattered_texture;

func _physics_process(delta: float) -> void:
    var movement_direction: Vector2 = Vector2.ZERO;
    movement_direction = Input.get_vector("Left", "Right", "Up", "Down").normalized();

    if (rpg_ui._in_menu): return;
    if (movement_direction != Vector2.ZERO):
        interaction_ray.target_position = movement_direction * (tile_size * 1.15);
    rpg_ui._current_interactable = get_interactable(interaction_ray);
    
    if (Input.is_action_pressed("Quaternary")):
        self._tile_speed = self.speed + self.sprint_mod;
    else:
        self._tile_speed = self.speed;
    self._tile_velocity = movement_direction;

    animate_player();
    super(delta);
