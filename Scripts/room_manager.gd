extends Node
class_name RoomManager

@export var player_ui: PlayerUI;
@export var wall_rect: TextureRect;
@export var floor_rect: TextureRect;
@export var battle_manager: BattleManager;

static var instance: RoomManager = null;

var enemy_prefab: PackedScene = preload("res://Scenes/Prefabs/enemy.tscn");

@onready var enemy_spawns: Array[Node2D] = [
    $EnemySpawn,
    $EnemySpawn2,
    $EnemySpawn3
];

@onready var boss_spawn: Node2D = $BossSpawn;

@export var current_dungeon: DungeonData;
var room_count: int = 1;

var room_stat_modifiers: Array[StatModifier] = [
    StatModifier.new(Enum.ModifierType.Additive, Enum.StatType.RoomDifficulty, 0, "tempDifficultyRoom"),
    StatModifier.new(Enum.ModifierType.Additive, Enum.StatType.RoomMultiplier, 0, "tempMultiplierRoom"),
];

var _room_multiplier: float = 1.0:
    get: return _room_multiplier;
    set (value):
        _room_multiplier = clamp(value, 1, 100);
var room_multiplier: float = 1.0:
    get: 
        return max(1, StatModifier.apply_stat_mods(room_stat_modifiers, Enum.StatType.RoomMultiplier, _room_multiplier));

var _room_difficulty: int = 1:
    get: return _room_difficulty;
    set (value):
        _room_difficulty = clampi(value, current_dungeon.minimum_difficulty, current_dungeon.maximum_difficulty);
var room_difficulty = 1:
    get: 
        @warning_ignore("narrowing_conversion") 
        return clampi(
            StatModifier.apply_stat_mods(room_stat_modifiers, Enum.StatType.RoomDifficulty, _room_difficulty), 
            current_dungeon.minimum_difficulty, 
            current_dungeon.maximum_difficulty
        );

var floor_count: int:
    get:
        @warning_ignore("integer_division")
        return int(room_count / current_dungeon.rooms_until_next_floor) + 1;
@export var player: Player;
@export var camera: Camera2D;

# wowie it's the function that scales EVERYTHING
func difficulty_adjust(scale_value: float, scale_factor: float = 0.11)-> int:
    var diff_scale: float = room_difficulty if room_difficulty > floor_count else floor_count;
    var scale_step_one: float = (scale_factor * diff_scale) + 0.5;
    var scale_step_two: float = scale_step_one * scale_value;
    var scale_step_three: int = floori(scale_step_two) if diff_scale <= current_dungeon.maximum_difficulty * 0.5 else ceili(scale_step_two);

    return scale_step_three;

func complete_dungeon(status: String):
    player_ui.fade_panel.visible = true;
    player_ui.fade_panel.modulate = Color(0, 0, 0, 0);
    var new_tween = get_tree().create_tween()
    new_tween.tween_property(
        player_ui.fade_panel, 
        "modulate", 
        Color(0, 0, 0, 1), 
        2.0 / Settings.game_speed
    ).set_delay(0.5);
    player_ui.game_completed.load_info(
        player, self,
        status
    );
    new_tween.tween_callback(func():
        player_ui.game_completed.visible = true;
    )
    
func load_enemy(enemy_data: EnemyData, difficulty: int = 1) -> Enemy:
    var new_enemy: Enemy = enemy_prefab.instantiate();
    new_enemy.load_enemy(enemy_data);
    new_enemy.name = enemy_data.name;
    new_enemy._max_health = max(difficulty_adjust(new_enemy.health), 1);
    new_enemy._max_stamina = max(difficulty_adjust(new_enemy.stamina), 1);
    new_enemy._attack = max(difficulty_adjust(new_enemy.attack), 1);
    new_enemy._max_defending_duration = max(difficulty_adjust(new_enemy._max_defending_duration, 0.12), 1);
    new_enemy._max_defense_durability = max(difficulty_adjust(new_enemy._max_defense_durability, 0.1), 1);
    return new_enemy;

func get_random_enemy(difficulty: int) -> Enemy:
    var selected_enemy: EnemyData = null;
    # an override pool ignores difficulty requirements
    if (player_ui.room_select.current_room.room_data.enemies.size() > 0):
        selected_enemy = player_ui.room_select.current_room.room_data.enemies.pick_random();
    else:
        selected_enemy = current_dungeon.enemies.pick_random();
        if (
            difficulty < selected_enemy.difficulty_range[0] 
            or difficulty > selected_enemy.difficulty_range[1]
        ):
            return get_random_enemy(difficulty);
    
    return load_enemy(selected_enemy, difficulty);

var difficulty_num_enemies = {
    1: [1, 1, 1, 1, 1, 2, 2, 2, 2, 3],
    5: [1, 1, 1, 2, 2, 2, 2, 2, 3, 3],
    7: [1, 1, 2, 2, 2, 2, 3, 3, 3, 3],
    10: [2, 2, 2, 2, 2, 3, 3, 3, 3, 3],
    15: [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
};

func get_num_enemies(difficulty: int):
    if (!difficulty_num_enemies.has(difficulty)): return get_num_enemies(difficulty - 1);

    return difficulty_num_enemies[difficulty][
        (room_count - 1) % 10
    ];

func get_alive_enemies() -> Array[Enemy]:
    var res: Array[Enemy] = [];
    for enemy in battle_manager.get_enemies():
        if (enemy.health <= 0): continue;
        res.append(enemy);
    return res;

func gen_room(decision: Enum.RoomDecision):	
    StatModifier.update_stat_mod(room_stat_modifiers, "tempDifficultyRoom", 0);
    StatModifier.update_stat_mod(room_stat_modifiers, "tempMultiplierRoom", 0);
    match (decision):
        Enum.RoomDecision.RiskIt:
            StatModifier.update_stat_mod(room_stat_modifiers, "tempDifficultyRoom", 2);
            StatModifier.update_stat_mod(room_stat_modifiers, "tempMultiplierRoom", 0.5);
        Enum.RoomDecision.StayClear:
            if (room_count % current_dungeon.rooms_until_next_floor != 0):
                room_count += 1;
            player.stamina += 5;
            StatModifier.update_stat_mod(room_stat_modifiers, "tempDifficultyRoom", 1);
    
    ItemUtils.activate_items(player, "room_decision", ItemFunction.ItemFunctionArgs.new_room_decision_args(decision));
    
    player.health += int(player.max_health * 0.4);
    
    var alive_enemies: Array[Enemy] = [];
    if (decision != Enum.RoomDecision.Boss):
        for i in range(get_num_enemies(room_difficulty)):
            var enemy = get_random_enemy(room_difficulty);
            enemy.enemy_index = i;
            enemy.pressed.connect(player_ui.select_enemy.bind(enemy));
            enemy.hover_area.mouse_entered.connect(player_ui.move_selection_box.bind(enemy));
            enemy.hover_area.mouse_exited.connect(player_ui.move_selection_box.bind(null));
            enemy_spawns[enemy.enemy_index].add_child(enemy);
            alive_enemies.append(enemy);
    else:
        var enemy = load_enemy(current_dungeon.boss_enemy, room_difficulty);
        enemy.enemy_index = 0;
        enemy.pressed.connect(player_ui.select_enemy.bind(enemy));
        enemy.hover_area.mouse_entered.connect(player_ui.move_selection_box.bind(enemy));
        enemy.hover_area.mouse_exited.connect(player_ui.move_selection_box.bind(null));
        boss_spawn.add_child(enemy);
        alive_enemies.append(enemy);

    battle_manager.start_battle(alive_enemies, player);
        
    print("Loaded Room");

var purchased_indicies = []; 
func purchase_item(item_name: String, item_display, display_index: int):
    var item = ItemUtils.get_item_data(item_name);
    if (player.coins <= 0 or player.coins < difficulty_adjust(item.price, 0.06)):
        return;
    
    player.coins -= difficulty_adjust(item.price, 0.06);
    ToastParty.show({
        "text": "Puchased %s!" % item.name,
        "text_size": Settings.toast_size,
        "bgcolor": Color(0, 0, 0, 1),
        "color": Color(1, 1, 1, 1),
        "gravity": "top",
        "direction": "right",
    });
    player.add_item(item_name);
    Audio.play_audio(Audio.purchase_sfx);
    player_ui.update_ui();
    item_display.hide();
    purchased_indicies.append(display_index);

func generate_shop_item(display_index: int):
    var item_display: Node2D = safe_room.get_node("Item"+str(display_index));
    item_display.show();
    var item_button: Button = item_display.get_node("Purchase");
    for connection in item_button.pressed.get_connections():
        item_button.pressed.disconnect(connection.callable)
    var item_name = ItemUtils.get_random_item(current_dungeon, display_index == 4);
    var item = ItemUtils.get_item_data(item_name);
    var item_sprite: AnimatedSprite2D = item_display.get_node("Sprite");
    item_sprite.animation = ItemUtils.get_item_animation_name(item);
    item_sprite.material.set_shader_parameter("outline_colour", ItemUtils.item_rarity_colours[item.rarity]);
    item_button.tooltip_strings.clear();
    item_button.tooltip_strings.append_array(ItemUtils.get_tooltip_text(item, true, true, difficulty_adjust(item.price, 0.06)));
    item_button.pressed.connect(purchase_item.bind(item_name, item_display, display_index));

func gen_safe_room_items():
    for i in range(1, 5):
        if (purchased_indicies.has(i)): continue;
        generate_shop_item(i);

@export var safe_room: Node2D;
@export var safe_room_anims: AnimationPlayer;
func gen_safe_room():
    camera.position = Vector2.ZERO;
    player.position = Vector2(225, 225);
    player.health = player.max_health;
    player.stamina = player.max_stamina;
    player.rerolls = player.max_rerolls;
    get_tree().create_tween().tween_property(player_ui.fade_panel, "modulate", Color(0, 0, 0, 0), 0.35);
    safe_room.get_parent().visible = true;

    purchased_indicies.clear();
    gen_safe_room_items();

    if (current_dungeon.id == Enum.Dungeon.Oceanic && floor_count == 2 && !GlobalPlayer.get_flag(&"bVendorMet")):
        safe_room_anims.play("VendorIntro");
        await safe_room_anims.animation_finished;
        player_ui.dialogue_box.start_dialogue.emit(load("res://Dialogue/vendor_intro.dialogue"));
        player_ui.stats_display.hide();
        player_ui.upgrades_panel.hide();
        player_ui.safe_room_proceed.hide();
        await player_ui.dialogue_box.dialogue_finished;
        player_ui.stats_display.show();
        safe_room_anims.play("VendorExit");
        await safe_room_anims.animation_finished;

    player_ui.toggle_safe_room(true);
    await player_ui.room_select.room_decision;
    if (floor_count % current_dungeon.difficulty_floor_increment == 0):
        _room_difficulty += 1;
    player.health = player.max_health;
    player.stamina = player.max_stamina;
    player.rerolls = player.max_rerolls;
    player_ui.room_select.request_floor(current_dungeon.rooms_until_next_floor, current_dungeon.rooms, self.room_difficulty);
    player_ui.toggle_safe_room(false);
    next_room(true);

func room_turn():
    while (battle_manager.battle_active()):
        await battle_manager.do_turn(self);
        player_ui.update_ui();
        await get_tree().create_timer(0.5 / Settings.game_speed).timeout
        player.update_shield();
    
    battle_manager.clear_battle();

    if (player.health <= 0):
        Audio.play_audio(Audio.die_sfx);
        player.play_anim(Enum.PlayerAnimation.Dead);
        complete_dungeon("DUNGEON FAILED");
        return;
    
    next_room();
    
func gen_next_room():
    var decision: Enum.RoomDecision = Enum.RoomDecision.Proceed;
    if (room_count >= current_dungeon.room_count):
        decision = Enum.RoomDecision.Boss;
    else:
        player_ui.room_select.request_room(self.room_count, self.current_dungeon.rooms_until_next_floor, current_dungeon.name.to_upper());
        decision = await player_ui.room_select.room_decision;
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
    var room_tween = camera.create_tween();
    room_tween.set_parallel();
    room_tween.tween_property(player, "position", Vector2(1025, 225), 1.0 / Settings.game_speed);
    room_tween.tween_property(player_ui.fade_panel, "modulate", Color(0, 0, 0, 1), 1.5 / Settings.game_speed);
    room_tween.set_parallel(false);
    safe_room.get_parent().visible = false;
    if (room_count > current_dungeon.room_count):
        GlobalPlayer.completed_dungeons[current_dungeon.id] = true;
        complete_dungeon("DUNGEON COMPLETE");
        return;
    elif (room_count % current_dungeon.rooms_until_next_floor == 0 && room_count < current_dungeon.room_count && !leaving_safe_room):
        room_tween.tween_callback(gen_safe_room).set_delay(0.2);
    else:
        room_tween.tween_callback(gen_next_room).set_delay(0.2);
    @warning_ignore("integer_division")
    if (room_count == current_dungeon.room_count / 2):
        Audio.change_music(Audio.DungeonMusic.Quickening);
    elif (room_count >= current_dungeon.room_count):
        Audio.change_music(Audio.DungeonMusic.BossFight);

func _ready() -> void:
    Audio.stop_music();
    if (!player.is_node_ready()): await player.ready;
    if (!player_ui.is_node_ready()): await player_ui.ready;
    MidnightDebug.room_manager = self;
    MidnightDebug.player = self.player;
    if (GlobalPlayer.current_dungeon):
        current_dungeon = GlobalPlayer.current_dungeon;
        if (current_dungeon.rooms.size() == 0): current_dungeon.rooms = player_ui.room_select.default_rooms;
    self.wall_rect.texture = self.current_dungeon.wall_texture;
    self.floor_rect.texture = self.current_dungeon.floor_texture;
    if (RoomManager.instance):
        RoomManager.instance.queue_free();
    RoomManager.instance = self;
    gen_room(Enum.RoomDecision.Proceed);
    player_ui.update_ui();
    player_ui.room_select.request_floor(current_dungeon.rooms_until_next_floor - 1, current_dungeon.rooms, self.room_difficulty);
    Audio.play_music(current_dungeon.dungeon_music);
    Audio.change_music(Audio.DungeonMusic.Idle);
    room_turn();

func _process(delta: float) -> void:
    if (Input.is_action_just_pressed("Reset")):
        SuperLoader.switch_scene("res://Scenes/game.tscn");
