extends Control
class_name StatsDisplay

@onready var coins_label: RichTextLabel = $Coins;
@onready var room_label: RichTextLabel = $Room;
@onready var health_bar: ProgressBar = $Health/Bar;
@onready var health_display: RichTextLabel = $Health/Display;
@onready var stamina_bar: ProgressBar = $Stamina/Bar;
@onready var stamina_display: RichTextLabel = $Stamina/Display;
@onready var defense_bar: ProgressBar = $Defense/Bar;
@onready var defense_display: RichTextLabel = $Defense/Display;
@onready var attack_bar: ProgressBar = $Attack/Bar;
@onready var attack_display: RichTextLabel = $Attack/Display;

@export var neo_mode: bool = false;

func update(room_manager: RoomManager) -> void:
    var player = room_manager.player;
    coins_label.text = "COINS: " + str(player.coins);
    room_label.text = "ROOM: " + str(room_manager.room_count);
    
    health_bar.max_value = player.max_health;
    health_bar.value = player.health;

    stamina_bar.max_value = player.max_stamina;
    stamina_bar.value = player.stamina;

    defense_bar.max_value = player.max_defending_duration;
    defense_bar.value = player.defending_duration;

    attack_bar.max_value = player.attack;
    attack_bar.value = player.attack;

    if (!neo_mode):
        health_display.text = "%d/%d" % [player.health, player.max_health];
        stamina_display.text = "%d/%d" % [player.stamina, player.max_stamina];
    else:
        health_display.text = "%d" % player.health;
        stamina_display.text = "%d" % player.stamina;
    
    if (player.defending_duration > 0):
        defense_display.text = "%d" % player.defense_durability;
    else:
        defense_display.text = "x";

    attack_display.text = "%d" % player.attack;
