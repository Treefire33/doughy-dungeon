extends Entity
class_name Enemy

@export var hover_check: Area2D;
@export var health_bar: ProgressBar;
@export var notif: Sprite2D;

var flavour_text: String = "placeholder";
var coin_drop_range = [0, 1];
var ai0_type = "Default";
var ai5_type = "Default";

static var enemies: Dictionary[String, EnemyData] = {
	"BiscuitMimic": preload("res://EnemyData/BiscuitMimic.tres"),
	"BiscuitMimic2": preload("res://EnemyData/BiscuitMimic2.tres"),
	"RollingPin": preload("res://EnemyData/RollingPin.tres"),
	"HardTack": preload("res://EnemyData/HardTack.tres"),
	"PretzelSpider": preload("res://EnemyData/PretzelSpider.tres"),
	"Loafer": preload("res://EnemyData/Loafer.tres"),
	"Dough": preload("res://EnemyData/Dough.tres"),
	"Doughnut": preload("res://EnemyData/Doughnut.tres"),
	"Cake": preload("res://EnemyData/Cake.tres"),
	"Oven": preload("res://EnemyData/Oven.tres"),
};

func load_enemy(enemy_data: EnemyData):
	load_entity(
		enemy_data.base_health,
		enemy_data.base_stamina,
		enemy_data.base_attack,
		self.get_node("Sprite"),
		enemy_data.sprite
	);
	self.flavour_text = enemy_data.flavour_text;
	self.coin_drop_range = enemy_data.coins_range;
	self.ai0_type = enemy_data.base_ai;
	self.ai5_type = enemy_data.base_ai_five;
	self.max_defending_duration = enemy_data.base_defense_duration;
	
var enemy_ais = {
	"Default": (func(_player): # Defend when low, chance attack otherwise.
		if (self.stamina == 0):
			return Enum.Decision.Rest;
		if (self.health < (0.2 * self.max_health) or randi_range(0, 10) > 5):
			return Enum.Decision.Defend;
		if (!self.defending_duration >= 1 and randi_range(0, 10) > 6):
			return Enum.Decision.Attack;
		return Enum.Decision.Rest;),
	"Random": (func(_player): # Completely random.
		return randi_range(0, 2);),
	"Aggressive": func(_player): # Focus on attack, defend when low, rest when no stamina.
		if (self.stamina == 0):
			return Enum.Decision.Rest;
		if (self.health < (0.1 * self.max_health) or randi_range(0, 10) > 6):
			return Enum.Decision.Defend;
		return Enum.Decision.Attack;,
	"Attack": func(_player): # Only attack.
		if (self.stamina == 0):
			return Enum.Decision.Rest;
		return Enum.Decision.Attack;,
	"Defensive": func(_player): # Focus on defense, attack when high health, rest when <2 stamina.
		if (self.stamina < 2):
			return Enum.Decision.Rest;
		if (self.health > (0.8 * self.max_health) and randi_range(0, 10) > 4):
			return Enum.Decision.Attack;
		if (self.defending_duration <= 0):
			return Enum.Decision.Defend;
		pass;,
	"Defend": func(_player): # Only defend.
		if (self.defending_duration > 1 or self.stamina == 0):
			return Enum.Decision.Rest;
		return Enum.Decision.Defend;,
	"Restless": func(_player): # Focus on stamina, chance attack or defense.
		var roll = randi_range(0, 10);
		if (self.stamina != 0):
			if (roll < 3): return Enum.Decision.Attack;
			elif (roll > 8): return Enum.Decision.Defend;
		return Enum.Decision.Defend;,
	"Rest": func(_player): # Only rest.
		if (randi_range(0, 100) == 99): return Enum.Decision.Attack;
		return Enum.Decision.Rest;,
	"Smart": func(player: Player): # decisions are also made based on the player's stats.
		# If player health and stamina is high, defend.
		# If player health is low, rest.
		# If player stamina is low, attack.
		# If player is defending, don't defend.
		if (player.stamina < (0.65 * player.max_stamina)):
			return Enum.Decision.Attack;
			
		if (self.stamina == 0 
			or player.defending_duration > 0
		):
			return Enum.Decision.Rest;
		
		if (randi_range(0, 10) > 3):
			return Enum.Decision.Attack;
			
		return Enum.Decision.Defend;,
}
	
func get_decision(player: Player, room_difficulty: int) -> Enum.Decision:
	if room_difficulty < 5:
		return enemy_ais[ai0_type].call(player);
	else:
		return enemy_ais[ai5_type].call(player);

func get_coin_drops() -> int:
	return randi_range(self.coin_drop_range[0], self.coin_drop_range[1])

func update_health():
	health_bar.value = float(health)/max_health;
