extends Control
class_name RPGInventory

@export var cloak_slot: Button;
@export var spell_slot_one: Button;
@export var spell_slot_two: Button;
@export var spell_slot_three: Button;
@export var sword_slot: Button;

@export var item_slot_prototype: Button;
@export var item_slot_container: Control;

const item_type_icon_dict: Dictionary[Enum.RPGItemType, Texture2D] = {
    Enum.RPGItemType.Cloak: preload("res://Sprites/Icons/MenuIcons/Cloak.tres"),
    Enum.RPGItemType.Sword: preload("res://Sprites/Icons/MenuIcons/Sword.tres"),
    Enum.RPGItemType.Spell: preload("res://Sprites/Icons/MenuIcons/Spell.tres"),
};

func _get_rpg_item_tooltip(rpg_item: RPGItemData) -> Array[String]:
    return [
        rpg_item.name,
        "", 
        "",
        rpg_item.description
    ];

func _update_equipped_display():
    cloak_slot.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.cloak);
    sword_slot.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.sword);
    spell_slot_one.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.spells[0]);
    spell_slot_two.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.spells[1]);
    spell_slot_three.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.spells[2]);

var current_equip_type: Enum.RPGItemType = Enum.RPGItemType.Cloak;
func _update_equippable_display_container():
    var display_type = current_equip_type;
    if current_equip_type > Enum.RPGItemType.Spell:
        display_type = Enum.RPGItemType.Spell;
    
    for item_name in GlobalPlayer.get_unlocked_items_of_type(display_type):
        var item_data = GlobalPlayer.rpg_item_database[item_name];

        if display_type == Enum.RPGItemType.Cloak && GlobalPlayer.cloak.resource_path == item_data.resource_path:
            continue;
        elif display_type == Enum.RPGItemType.Sword && GlobalPlayer.sword.resource_path == item_data.resource_path:
            continue;
        elif display_type == Enum.RPGItemType.Spell && GlobalPlayer.spells[current_equip_type - Enum.RPGItemType.Spell].resource_path == item_data.resource_path:
            continue;

        var new_slot: Button = item_slot_prototype.duplicate();
        new_slot.icon = item_data.icon_override if is_instance_valid(item_data.icon_override) else item_type_icon_dict[display_type];
        new_slot.text = item_data.name;
        new_slot.disabled = false;
        new_slot.visible = true;
        new_slot.pressed.connect(_equip_item.bind(item_name));
        new_slot.tooltip_strings = _get_rpg_item_tooltip(item_data);
        item_slot_container.add_child(new_slot);

func _update_equippable_display(item_type: Enum.RPGItemType):
    if (item_type < 0): return;
    
    for child in item_slot_container.get_children():
        if (!(child is Button)): continue;
        child.queue_free();

    current_equip_type = item_type;
    _update_equippable_display_container();

func _equip_item(item_name: StringName):
    GlobalPlayer.equip_item(current_equip_type, item_name);
    _update_equipped_display();

func _ready() -> void:
    cloak_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Cloak));
    sword_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Sword));
    spell_slot_one.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Spell));
    spell_slot_two.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Spell + 1));
    spell_slot_three.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Spell + 2));

    _update_equippable_display_container();
    _update_equipped_display();
