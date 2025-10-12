extends Control
class_name StatsDisplay

@onready var coins_label: RichTextLabel = $Coins;
@onready var attack_label: RichTextLabel = $Attack;
@onready var room_label: RichTextLabel = $Room;
@onready var health_bar: ProgressBar = $Health/Bar;
@onready var health_display: RichTextLabel = $Health/Display;
@onready var stamina_bar: ProgressBar = $Stamina/Bar;
@onready var stamina_display: RichTextLabel = $Stamina/Display;

func update(room_manager: RoomManager) -> void:
	var player = room_manager.player;
	coins_label.text = "COINS: " + str(player.coins);
	attack_label.text = "ATTACK: " + str(player.attack);
	room_label.text = "ROOM: " + str(room_manager.room_count);
	
	health_bar.max_value = player.max_health;
	health_bar.value = player.health;
	health_display.text = "%s/%s" % [player.health, player.max_health];
	
	stamina_bar.max_value = player.max_stamina;
	stamina_bar.value = player.stamina;
	stamina_display.text = "%s/%s" % [player.stamina, player.max_stamina];
