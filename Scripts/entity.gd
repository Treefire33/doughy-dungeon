extends Node2D
class_name Entity

var max_health: int;
var health: int:
	get: return health
	set (value):
		if (health > value):
			self.call_deferred("hurt")
		health = clampi(value, 0, max_health)

var max_stamina: int;
var stamina: int:
	get: return stamina
	set (value):
		stamina = clampi(value, 0, max_stamina)

var attack: int = 1;
var max_defending_duration: int = 1;
var defending_duration: int:
	get: return defending_duration;
	set (value):
		defending_duration = clampi(value, 0, max_defending_duration);

var _is_animated_sprite = false;
var sprite: Variant:
	get: 
		if (_is_animated_sprite):
			return sprite as AnimatedSprite2D;
		else:
			return sprite as Sprite2D;
	
	set (value):
		sprite = value;

func hurt():
	self.sprite.modulate = Color(1, 1, 1, 0);
	var passes = 0;
	while (passes < 6):
		self.sprite.modulate = Color(1, 1, 1, 0 if passes % 2 == 0 else 1);
		await get_tree().create_timer(0.1 / Settings.game_speed).timeout;
		passes += 1;

func load_entity(
	max_health: int, 
	max_stamina: int, 
	attack: int, 
	sprite: Variant,
	sprite_frames: SpriteFrames = null
):
	self.max_health = max_health;
	self.health = self.max_health;
	self.max_stamina = max_stamina;
	self.stamina = self.max_stamina;
	self.attack = attack;
	
	self.sprite = sprite;
	if (sprite is AnimatedSprite2D):
		_is_animated_sprite = true;
	else:
		return;
	
	self.sprite.sprite_frames = sprite_frames;
	self.sprite.play("Idle");
