extends Control
class_name RPGInventory

@export var cloak_slot: Button;
@export var sword_slot: Button;
@export var spell_slot: Button;

@export var item_slot_prototype: Button;
@export var item_slot_container: Control;

@export var stats_display_health: RichTextLabel;
@export var stats_display_stamina: RichTextLabel;
@export var stats_display_attack: RichTextLabel;
@export var stats_display_duration: RichTextLabel;
@export var stats_display_durability: RichTextLabel;
@export var stats_display_speed: RichTextLabel;

const item_type_icon_dict: Dictionary[Enum.RPGItemType, Texture2D] = {
    Enum.RPGItemType.Cloak: preload("res://Sprites/Icons/MenuIcons/Cloak.tres"),
    Enum.RPGItemType.Sword: preload("res://Sprites/Icons/MenuIcons/Sword.tres"),
    Enum.RPGItemType.ShieldSpell: preload("res://Sprites/Icons/MenuIcons/ShieldSpell.tres"),
};

func _update_equipped_display():
    cloak_slot.text = GlobalPlayer.cloak.name;
    sword_slot.text = GlobalPlayer.sword.name;
    spell_slot.text = GlobalPlayer.shield_spell.name;

func _update_stats_display():
    stats_display_health.text = "HEALTH: %d" % GlobalPlayer.get_upgrade_stat("max_health");
    stats_display_stamina.text = "STAMINA: %d" % GlobalPlayer.get_upgrade_stat("max_stamina");
    stats_display_attack.text = "ATTACK: %d" % GlobalPlayer.get_upgrade_stat("attack");
    stats_display_duration.text = "DEF. DURATION: %d" % GlobalPlayer.get_upgrade_stat("max_defense_duration");
    stats_display_durability.text = "DEF. DURABILITY: %d" % GlobalPlayer.get_upgrade_stat("max_defense_durability");
    stats_display_speed.text = "SPEED: %d" % max(2, GlobalPlayer.get_upgrade_stat("speed"));

var current_display_type: Enum.RPGItemType = Enum.RPGItemType.Cloak;
func _update_equippable_display_container():
    for item_name in GlobalPlayer.get_unlocked_items_of_type(current_display_type):
        var item_data = GlobalPlayer.rpg_item_database[item_name];
        var new_slot: Button = item_slot_prototype.duplicate();
        new_slot.icon = item_data.icon_override if is_instance_valid(item_data.icon_override) else item_type_icon_dict[current_display_type];
        new_slot.text = item_data.name;
        new_slot.disabled = false;
        new_slot.visible = true;
        new_slot.pressed.connect(_equip_item.bind(item_name));
        item_slot_container.add_child(new_slot);

func _update_equippable_display(item_type: Enum.RPGItemType):
    if (item_type == -2): item_type = current_display_type;
    for child in item_slot_container.get_children():
        if (!(child is Button)): continue;

        if (item_type < 0): child.disabled = true;
        elif (item_type == current_display_type): child.disabled = false;
        else: child.queue_free();

    if (item_type < 0): return;
    if (current_display_type == item_type): return;

    current_display_type = item_type;
    _update_equippable_display_container();

func _equip_item(item_name: StringName):
    GlobalPlayer.equip_item(current_display_type, item_name);
    _update_equipped_display();
    _update_stats_display();

func _ready() -> void:
    cloak_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Cloak));
    cloak_slot.mouse_exited.connect(_update_equippable_display.bind(-1));

    sword_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Sword));
    sword_slot.mouse_exited.connect(_update_equippable_display.bind(-1));

    spell_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.ShieldSpell));
    spell_slot.mouse_exited.connect(_update_equippable_display.bind(-1));

    item_slot_container.mouse_entered.connect(_update_equippable_display.bind(-2));
    item_slot_container.mouse_exited.connect(_update_equippable_display.bind(-1));

    _update_equippable_display_container();
    _update_equipped_display();
    _update_stats_display();
