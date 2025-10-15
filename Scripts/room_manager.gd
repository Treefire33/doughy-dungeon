extends Node
class_name RoomManager

signal request_decision;
@export var player_ui: PlayerUI;
@export var wall_rect: TextureRect;
@export var floor_rect: TextureRect;

var enemy_prefab: PackedScene = preload("res://Scenes/Prefabs/enemy.tscn");

@onready var enemy_spawns: Array[Node2D] = [
	$EnemySpawn,
	$EnemySpawn2,
	$EnemySpawn3
]

var current_dungeon: DungeonData;
var room_count: int = 1;
var temp_difficulty = 0;
var streak_difficulty = 0;
var room_difficulty = 1:
	get: return clampi(room_difficulty + temp_difficulty + streak_difficulty, 1, 10);
	set (value):
		room_difficulty = clampi(value, 1, 10);
var temp_multiplier: float = 0.0;
var streak_multiplier: float = 0.0;
var room_multiplier: float = 1.0:
	get: return clamp(room_multiplier + temp_multiplier + streak_multiplier, 1, 100);
	set (value):
		room_multiplier = clamp(value, 1, 100);
var floor_count: int:
	get:
		return int(room_count / current_dungeon.rooms_until_next_floor) + 1;
@export var player: Player;
@export var camera: Camera2D;
	
func get_random_enemy(difficulty: int) -> Enemy:
	var selected_enemy = current_dungeon.enemies.pick_random();
	if (
		difficulty < selected_enemy.difficulty_range[0] 
		or difficulty > selected_enemy.difficulty_range[1]
	):
		return get_random_enemy(difficulty)
	var new_enemy: Enemy = enemy_prefab.instantiate();
	new_enemy.load_enemy(selected_enemy);
	new_enemy.name = selected_enemy.name
	return new_enemy;

var alive_enemies: Array[Enemy] = [null, null, null];
var difficulty_num_enemies = {
	1: [1, 1, 1, 1, 1, 2, 2, 2, 2, 3], 2: [1, 1, 1, 1, 1, 2, 2, 2, 2, 3],
	3: [1, 1, 1, 1, 1, 2, 2, 2, 2, 3], 4: [1, 1, 1, 1, 1, 2, 2, 2, 2, 3],
	
	5: [1, 1, 1, 2, 2, 2, 2, 2, 3, 3], 6: [1, 1, 1, 2, 2, 2, 2, 2, 3, 3],
	
	7: [1, 1, 2, 2, 2, 2, 3, 3, 3, 3], 8: [1, 1, 2, 2, 2, 2, 3, 3, 3, 3],
	9: [1, 1, 2, 2, 2, 2, 3, 3, 3, 3],
	
	10: [2, 2, 2, 2, 2, 3, 3, 3, 3, 3]
};

func gen_room(decision: Enum.RoomDecision):	
	temp_difficulty = 0;
	temp_multiplier = 0;
	match (decision):
		Enum.RoomDecision.RiskIt:
			temp_difficulty = 2;
			temp_multiplier = .5;
		Enum.RoomDecision.StayClear:
			if (room_count % current_dungeon.rooms_until_next_floor != 0):
				room_count += 1;
			player.stamina += 5;
			temp_difficulty = 1;
			
	for item in player.get_items("room_decision"):
		var result = ItemUtils.execute_item_func(item.room_decision, self, decision);
		if (result):
			ToastParty.show({
				"text": "%s activated!" % item.name,
				"text_size": Settings.toast_size,
				"bgcolor": Color(0, 0, 0, 1),
				"color": Color(1, 1, 1, 1),
				"gravity": "top",
				"direction": "right",
			})
	
	player.health += int(player.max_health * 0.4);
	
	var num_enemies = difficulty_num_enemies[
		room_difficulty
	][(room_count - 1) % 10];
	
	for i in range(num_enemies):
		var enemy = get_random_enemy(room_difficulty);
		enemy_spawns[i].add_child(enemy);
		alive_enemies[i] = enemy;
		
	print("Loaded Room");
	
func purchase_item(item: ItemData, item_display):
	if (player.coins <= 0 or player.coins < item.price):
		return;
	
	player.coins -= item.price;
	player.items.append(item);
	ToastParty.show({
		"text": "Puchased %s!" % item.name,
		"text_size": Settings.toast_size,
		"bgcolor": Color(0, 0, 0, 1),
		"color": Color(1, 1, 1, 1),
		"gravity": "top",
		"direction": "right",
	})
	if (item.purchased != null):
		var result = ItemUtils.execute_item_func(item.purchased, player);
		if (result):
			ToastParty.show({
				"text": "%s activated!" % item.name,
				"text_size": Settings.toast_size,
				"bgcolor": Color(0, 0, 0, 1),
				"color": Color(1, 1, 1, 1),
				"gravity": "top",
				"direction": "right",
			})
	Audio.play_audio(get_node("/root/"), Audio.purchase_sfx);
	player_ui.update_ui();
	item_display.hide();

@export var safe_room: Node2D;
@export var golden_biscuit: Node2D;
func gen_safe_room():
	camera.position = Vector2.ZERO;
	player.position = Vector2(225, 225);
	player.health = player.max_health;
	player.stamina = player.max_stamina;
	player_ui.update_ui();
	get_tree().create_tween().tween_property(player_ui.fade_panel, "modulate", Color(0, 0, 0, 0), 0.35)
	if (room_count >= current_dungeon.room_count):
		golden_biscuit.visible = true;
		Settings.room_count = 100;
		var final_scene = get_tree().create_tween()
		final_scene.tween_property(
			player_ui.fade_panel, 
			"modulate", 
			Color(0, 0, 0, 1), 
			0.35
		).set_delay(2)
		final_scene.tween_callback(func():
			get_tree().change_scene_to_file("res://Scenes/game_win.tscn");
		)
		return;
	safe_room.get_parent().visible = true;
	player_ui.safe_room_proceed.show();
	player_ui.upgrades_panel.show();
	player_ui.in_safe_room = true;
	for i in range(1, 4):
		var item_display: Node2D = safe_room.get_node("Item"+str(i))
		item_display.show();
		var item_button: Button = item_display.get_node("Purchase");
		for connection in item_button.pressed.get_connections():
			item_button.pressed.disconnect(connection.callable)
		var item = ItemUtils.get_random_item(current_dungeon);
		item_display.get_node("Sprite").texture = item.sprite;
		item_button.tooltip_text = item.name + \
		"\n" + item.flavour_text + \
		"\n\n" + "Price: " + str(item.price) + "\n" + item.description;
		item_button.pressed.connect(purchase_item.bind(item, item_display))
	await player_ui.room_select.room_decision;
	player_ui.safe_room_proceed.hide();
	player_ui.upgrades_panel.hide();
	player_ui.in_safe_room = false;
	if (floor_count % current_dungeon.difficulty_floor_increment == 0):
		room_difficulty += 1;
	player.health = player.max_health;
	player.stamina = player.max_stamina;
	player_ui.update_ui();
	next_room(true);
	
func turn_attack(user: Entity, target: Entity):
	if (target == null): return;
	if (target.defending_duration >= 1): 
		target.defense_durability -= 1;
		return;
	if (user.stamina <= 0): return;
	user.stamina -= 1;
	Audio.play_audio(get_node("/root/"), Audio.hit_sfx);
	target.health -= user.attack;
	
func turn_defend(user: Entity, _target):
	if (user.stamina <= 0): return;
	user.stamina -= 1;
	if (user.defending_duration != 0): return;
	Audio.play_audio(get_node("/root/"), Audio.defend_sfx);
	user.defending_duration = user.max_defending_duration;
	
func turn_rest(user: Entity, _target):
	if (user.stamina > user.max_stamina): 
		user.stamina = user.max_stamina;
	user.stamina += 1;
	
var turn_functions = [
	turn_attack,
	turn_defend,
	turn_rest
]

func decision_text(decision: Enum.Decision):
	match decision:
		Enum.Decision.Attack:
			return "attacked";
		Enum.Decision.Defend:
			return "started defending";
		Enum.Decision.Rest:
			return "rested";

func get_enemies_alive():
	var num = 0;
	for enemy in alive_enemies:
		if enemy == null:
			continue
		num += 1;
	return num;

func room_turn():
	var current_turn = 0;
	while (get_enemies_alive() > 0 and player.health > 0):
		match (current_turn):
			0:
				if (player.stamina > 0):
					player.play_anim(Enum.PlayerAnimation.Idle);
				player.defending_duration -= 1;
				request_decision.emit();
				var decision_info = await player_ui.player_decision;
				var decision: Enum.Decision = decision_info[0];
				var selected_enemy = decision_info[1];
				turn_functions[decision].call(player, selected_enemy)
				if (player.stamina <= 0):
					player.play_anim(Enum.PlayerAnimation.Rest);
				else:
					player.play_anim(decision + 1);
				
				for item in player.get_items("decision"):
					var result = ItemUtils.execute_item_func(item.decision, player, selected_enemy, decision);
					if (result):
						ToastParty.show({
							"text": "%s activated!" % item.name,
							"text_size": Settings.toast_size,
							"bgcolor": Color(0, 0, 0, 1),
							"color": Color(1, 1, 1, 1),
							"gravity": "top",
							"direction": "right",
						});
					
				current_turn = 1;
				if (selected_enemy == null):
					continue
				selected_enemy.update_health();
				if (selected_enemy.health <= 0):
					for item in player.get_items("enemy_kill"):
						var result = ItemUtils.execute_item_func(item.enemy_kill, player, selected_enemy);
						if (result):
							ToastParty.show({
								"text": "%s activated!" % item.name,
								"text_size": Settings.toast_size,
								"bgcolor": Color(0, 0, 0, 1),
								"color": Color(1, 1, 1, 1),
								"gravity": "top",
								"direction": "right",
							});
					
					Audio.play_audio(get_node("/root/"), Audio.die_sfx);
					player.coins += int(selected_enemy.get_coin_drops() * room_multiplier);
					selected_enemy.queue_free()
					var index = alive_enemies.find(selected_enemy);
					alive_enemies[index] = null;
			1:
				for enemy in alive_enemies:
					if (enemy == null):
						continue;
					enemy.notif.frame = 5;
					enemy.defending_duration -= 1;
					var decision = enemy.get_decision(player, room_difficulty);
					turn_functions[decision].call(
						enemy, 
						player
					)
					ToastParty.show({
						"text": enemy.name + " " + decision_text(decision) + "!",
						"text_size": Settings.toast_size,
						"bgcolor": Color(0, 0, 0, 1),
						"color": Color(1, 1, 1, 1),
						"gravity": "top",
						"direction": "right",
					})
					enemy.notif.frame = 3 if enemy.defending_duration >= 1 else 5;
					
				current_turn = 0;
		player_ui.update_ui();
		await get_tree().create_timer(0.5 / Settings.game_speed).timeout
		player.update_shield();
	
	if (player.health <= 0):
		Audio.play_audio(get_node("/root/"), Audio.die_sfx);
		player.play_anim(Enum.PlayerAnimation.Dead);
		var new_tween = get_tree().create_tween()
		new_tween.tween_property(
			player_ui.fade_panel, 
			"modulate", 
			Color(0, 0, 0, 1), 
			2.0 / Settings.game_speed
		).set_delay(0.5);
		new_tween.tween_callback(func():
			Settings.room_count = room_count;
			get_tree().change_scene_to_file("res://Scenes/game_over.tscn");
		)
		return
	
	next_room()
	
func gen_next_room():
	player_ui.room_select.request_room(self.room_count, self.current_dungeon.rooms_until_next_floor);
	var decision: Enum.RoomDecision = await player_ui.room_select.room_decision;
	camera.position = Vector2.ZERO;
	player.position = Vector2(225, 225);
	get_tree().create_tween().tween_property(player_ui.fade_panel, "modulate", Color(0, 0, 0, 0), 0.35)
	room_count += 1;
	gen_room(decision);
	player_ui.update_ui();
	room_turn();
	
func next_room(leaving_safe_room: bool = false):
	player.play_anim(Enum.PlayerAnimation.Idle);
	player_ui.fade_panel.modulate = Color(0, 0, 0, 0);
	player_ui.fade_panel.visible = true;
	var room_tween = camera.create_tween()
	room_tween.set_parallel()
	room_tween.tween_property(player, "position", Vector2(1025, 225), 1.0 / Settings.game_speed)
	room_tween.tween_property(player_ui.fade_panel, "modulate", Color(0, 0, 0, 1), 1.5 / Settings.game_speed)
	room_tween.set_parallel(false)
	safe_room.get_parent().visible = false;
	if (room_count % current_dungeon.rooms_until_next_floor == 0 and !leaving_safe_room):
		room_tween.tween_callback(gen_safe_room).set_delay(0.2)
	else:
		room_tween.tween_callback(gen_next_room).set_delay(0.2)

func _ready() -> void:
	await player.player_ready;
	MidnightDebug.room_manager = self;
	MidnightDebug.player = self.player;
	self.current_dungeon = load("res://Dungeons/DoughyDungeon.tres");
	self.wall_rect.texture = self.current_dungeon.wall_texture;
	self.floor_rect.texture = self.current_dungeon.floor_texture;
	gen_room(Enum.RoomDecision.Proceed);

var pause_menu: PackedScene = preload("res://Scenes/Menus/PauseMenu/pause_menu.tscn");
var paused: bool = false;
func pause_game():
	paused = true;
	var new_pause_menu: PauseMenu = pause_menu.instantiate();
	player_ui.add_child(new_pause_menu);
	new_pause_menu.load_pause_menu(self);

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Pause") and !paused):
		pause_game()
	if (Input.is_action_just_pressed("Reset")):
		get_tree().change_scene_to_file("res://Scenes/game.tscn");

func _on_player_ui_ui_done() -> void:
	room_turn()
