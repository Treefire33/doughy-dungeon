extends CharacterBody2D
class_name RPGEntity

static var tile_size: Vector2 = Vector2(64, 64);

var _moving: bool = false;
var _current_move_tween: Tween = null;
@export var static_body: bool = false;

var _tile_velocity: Vector2 = Vector2.ZERO;
var _tile_position: Vector2 = Vector2.ZERO;
var _tile_speed: int = 5;
var _last_direction: Vector2 = Vector2.ZERO;

func _set_collision(enabled: bool = true) -> void:
    var collider = get_node("Collider") as CollisionShape2D;
    collider.disabled = !enabled;

func _physics_process(delta: float) -> void:
    if (static_body): return;

    _moving = _tile_velocity != Vector2.ZERO;
    var entity_speed: Vector2 = (_tile_velocity * _tile_speed) * tile_size;
    if (_moving):
        if (_current_move_tween):
            _current_move_tween.stop();
            _current_move_tween = null;
        self.velocity = entity_speed;
        self.move_and_slide();
        self._tile_position = round((self.position + (tile_size / 2 * _last_direction)) / tile_size);
    elif (!_current_move_tween && _tile_velocity != _last_direction):
        pass;
    _last_direction = _tile_velocity;
