extends Panel
class_name RPGStats

@export var stats_display_health: RichTextLabel;
@export var stats_display_stamina: RichTextLabel;
@export var stats_display_attack: RichTextLabel;
@export var stats_display_duration: RichTextLabel;
@export var stats_display_durability: RichTextLabel;
@export var stats_display_speed: RichTextLabel;
@export var stats_display_coins: RichTextLabel;

func _update_stats_display():
    stats_display_health.text = "HEALTH: %d" % GlobalPlayer.get_upgrade_stat("max_health");
    stats_display_stamina.text = "STAMINA: %d" % GlobalPlayer.get_upgrade_stat("max_stamina");
    stats_display_attack.text = "ATTACK: %d" % GlobalPlayer.get_upgrade_stat("attack");
    stats_display_duration.text = "DEF. DURATION: %d" % GlobalPlayer.get_upgrade_stat("max_defense_duration");
    stats_display_durability.text = "DEF. DURABILITY: %d" % GlobalPlayer.get_upgrade_stat("max_defense_durability");
    stats_display_speed.text = "SPEED: %d" % max(2, GlobalPlayer.get_upgrade_stat("speed"));
    stats_display_coins.text = "COINS: %d¢" % GlobalPlayer.coins;

func _process(delta: float) -> void:
    _update_stats_display();
