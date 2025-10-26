extends Node2D
class_name Entity
signal durability_changed;

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

var max_defense_durability: int = 1;
var defense_durability: int = 1:
	get: return defense_durability;
	set(value): 
		defense_durability = clampi(value, 0, max_defense_durability);
		if (defense_durability == 0):
			defending_duration = 0;
			defense_durability = max_defense_durability;
		durability_changed.emit();

var sprite: Sprite2D;
var animator: AnimationPlayer;

func hurt():
	self.sprite.modulate = Color(1, 1, 1, 0);
	var passes = 0;
	while (passes < 6):
		self.sprite.modulate = Color(1, 1, 1, 0 if passes % 2 == 0 else 1);
		await get_tree().create_timer(0.1 / Settings.game_speed).timeout;
		passes += 1;

func load_entity(
	_max_health: int, 
	_max_stamina: int, 
	_attack: int, 
	_sprite: Sprite2D,
	_animator: AnimationPlayer
):
	self.max_health = _max_health;
	self.health = self.max_health;
	self.max_stamina = _max_stamina;
	self.stamina = self.max_stamina;
	self.attack = _attack;
	
	self.sprite = _sprite;
	self.animator = _animator;
