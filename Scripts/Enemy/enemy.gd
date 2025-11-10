extends Entity
class_name Enemy

@export var hover_check: Area2D;
@export var health_bar: ProgressBar;
@export var notif: Sprite2D;

var flavour_text: String = "placeholder";
var coin_drop_range = [0, 1];
var ai0_type = "Default";
var ai5_type = "Default";
var selection_ai_type = "Player";

func load_enemy(enemy_data: EnemyData):
	load_entity(
		enemy_data.base_health,
		enemy_data.base_stamina,
		enemy_data.base_attack,
		$Sprite,
		$Animator
	);
	self.sprite.texture = enemy_data.sprite;
	self.animator.play("Enemy/Idle");
	self.flavour_text = enemy_data.flavour_text;
	self.coin_drop_range = enemy_data.coins_range;
	self.ai0_type = enemy_data.base_ai;
	self.ai5_type = enemy_data.base_ai_five;
	self.selection_ai_type = enemy_data.target_selection_ai;
	self.max_defending_duration = enemy_data.base_defense_duration;
	self.max_defense_durability = enemy_data.base_defense_durability;
	self.defense_durability = self.max_defending_duration;
	
var target_selection_ais = {
	"Player": func(player: Player, _other_enemies: Array[Enemy]):
		return player;,
	"Random": func(player: Player, other_enemies: Array[Enemy]):
		var target = null;
		while (target == self):
			target = ([player] + other_enemies).pick_random();
		return target,
	"Target": func(player: Player, other_enemies: Array[Enemy]): # Exclusive to Anemone, who targets Jellyfish
		for enemy in other_enemies:
			if (enemy == self || enemy == null):
				continue;
			if (enemy.name == "Jellyfish"):
				return enemy;
		return player;
};

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
		return Enum.Decision.Rest,
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
};
	
func get_decision(player: Player, room_difficulty: int) -> Enum.Decision:
	if room_difficulty < 5:
		return enemy_ais[ai0_type].call(player);
	else:
		return enemy_ais[ai5_type].call(player);

func get_target(player: Player, other_enemies: Array[Enemy]) -> Entity:
	return target_selection_ais[selection_ai_type].call(player, other_enemies);

func get_coin_drops() -> int:
	return randi_range(self.coin_drop_range[0], self.coin_drop_range[1])

func update_health():
	health_bar.value = float(health)/max_health;
