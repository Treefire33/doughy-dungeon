extends Control
class_name GameOver

@export var completion_status: RichTextLabel;
@export var item_icon: TextureRect;
@export var item_container: GridContainer;

@onready var try_again_button: Button = $Buttons/TryAgain;
@onready var continue_button: Button = $Buttons/Continue;

@export var room_reached: RichTextLabel;
@export var max_health: RichTextLabel;
@export var max_stamina: RichTextLabel;
@export var attack: RichTextLabel;
@export var damage_taken: RichTextLabel;

func _ready() -> void:
    try_again_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://Scenes/game.tscn");    
    );
    continue_button.pressed.connect(func():
        get_tree().change_scene_to_file("res://Scenes/rpg_test.tscn");
    );

func load_info(player: Player, room_manager: RoomManager, status: String):
    for item in player.items:
        var count = player.items[item];
        var data = ItemUtils.get_item_data(item);
        var new_item = item_icon.duplicate();
        var item_tooltip: TooltipTrigger = new_item.get_node("TooltipTrigger");
        new_item.visible = true;
        item_tooltip.text = ItemUtils.get_tooltip_text(data, false);
        new_item.get_node("Count").text = str(count);
        new_item.texture = data.sprite;
        item_container.add_child(new_item);
    
    completion_status.text = status;
    room_reached.text = "ROOM REACHED: %d" % room_manager.room_count;
    max_health.text = "MAX HEALTH: %d" % player.max_health;
    max_stamina.text = "MAX STAMINA: %d" % player.max_stamina;
    attack.text = "ATTACK: %d" % player.attack;
    damage_taken.text = "DEFENSE: %d/%d" % [player.max_defense_durability, player.max_defending_duration];
