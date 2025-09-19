extends Control
class_name StatsDisplay

@onready var coins_label: RichTextLabel = $Coins;
@onready var attack_label: RichTextLabel = $Attack;
@onready var room_label: RichTextLabel = $Room;
@onready var health_bar: ProgressBar = $Health/Bar;
@onready var stamina_bar: ProgressBar = $Stamina/Bar;

func update(room_manager: RoomManager) -> void:
	var player = room_manager.player;
	coins_label.text = "COINS: " + str(player.coins);
	attack_label.text = "ATTACK: " + str(player.attack);
	room_label.text = "ROOM: " + str(room_manager.room_count);
	
	health_bar.max_value = player.max_health;
	health_bar.value = player.health;
	
	stamina_bar.max_value = player.max_stamina;
	stamina_bar.value = player.stamina;
