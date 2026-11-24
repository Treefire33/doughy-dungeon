extends Control
class_name GameOver

@export var completion_status: RichTextLabel;
@export var item_icon: AnimatedTextureRect;
@export var item_container: GridContainer;

@onready var try_again_button: Button = $Buttons/TryAgain;
@onready var continue_button: Button = $Buttons/Continue;

@export var room_reached: RichTextLabel;
@export var max_health: RichTextLabel;
@export var max_stamina: RichTextLabel;
@export var attack: RichTextLabel;
@export var damage_taken: RichTextLabel;
@export var coins: RichTextLabel;

func _ready() -> void:
    try_again_button.pressed.connect(func():
        SuperLoader.switch_scene("res://Scenes/game.tscn");    
    );
    continue_button.pressed.connect(func():
        RPGManager.move_rooms(&"TEST_SCENE");
    );

func load_info(player: Player, room_manager: RoomManager, status: String, profit: int):
    for item in player.items:
        var count = player.items[item];
        var data = ItemUtils.get_item_data(item);
        var new_item = item_icon.duplicate();
        var item_tooltip: TooltipTrigger = new_item.get_node("TooltipTrigger") as TooltipTrigger;
        new_item.visible = true;
        item_tooltip.tooltip_strings.append_array(ItemUtils.get_tooltip_text(data, false, player));
        new_item.get_node("Count").text = str(count);
        new_item.play(ItemUtils.get_item_animation_name(data));
        item_container.add_child(new_item);
    
    completion_status.text = status;
    room_reached.text = "ROOM REACHED: %d" % room_manager.room_count;
    max_health.text = "MAX HEALTH: %d" % player.max_health;
    max_stamina.text = "MAX STAMINA: %d" % player.max_stamina;
    attack.text = "ATTACK: %d" % player.attack;
    damage_taken.text = "DEFENSE: %d/%d" % [player.max_defense_durability, player.max_defending_duration];
    coins.text = "COMMISSION: +%d¢" % profit;
