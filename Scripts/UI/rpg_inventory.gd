extends Control
class_name RPGInventory

@export var cloak_slot: Button;
@export var spell_slots: Array[Button];
@export var sword_slot: Button;

@export var item_slot_prototype: Button;
@export var item_slot_container: Control;

const item_type_icon_dict: Dictionary[Enum.RPGItemType, Texture2D] = {
    Enum.RPGItemType.Cloak: preload("res://Sprites/Icons/MenuIcons/Cloak.tres"),
    Enum.RPGItemType.Sword: preload("res://Sprites/Icons/MenuIcons/Sword.tres"),
    Enum.RPGItemType.Spell: preload("res://Sprites/Icons/MenuIcons/Spell.tres"),
};

const spec_dict = {
    Enum.SpellSpecification.None: "None",
    Enum.SpellSpecification.Attack: "Attack",
    Enum.SpellSpecification.Defend: "Defend",
    Enum.SpellSpecification.Activate: "Activate",
    Enum.SpellSpecification.Special: "Special",
};
const stat_increase_template: String = "%s: +%d";
const attr_dict = {
    "max_health": "Health",
    "max_stamina": "Stamina",
    "attack": "Attack",
    "max_defense_duration": "Def. Duration",
    "max_defense_durability": "Def. Durability",
    "speed": "Speed"
}
static var _cached_tooltips: Dictionary[RPGItemData, Array] = {};
static func _generate_rpg_item_tooltips():
    for rpg_item_name in GlobalPlayer.rpg_item_database:
        var rpg_item: RPGItemData = GlobalPlayer.rpg_item_database[rpg_item_name];
        var specification: String = "";
        if (rpg_item is SpellItemData):
            specification = "Specification: %s" % spec_dict[rpg_item.function.new().specification()];

        var tooltip_strings: Array[String] = [
            rpg_item.name, 
            specification, 
            rpg_item.description
        ];

        # for attr in attr_dict:
        #     if (rpg_item.get(attr) == 0): continue;
        #     tooltip_strings.append(stat_increase_template % [attr_dict[attr], rpg_item.get(attr)]);

        _cached_tooltips[rpg_item] = tooltip_strings;

func _get_rpg_item_tooltip(rpg_item: RPGItemData) -> Array[String]:
    var tooltip_strings: Array[String] = _cached_tooltips.get(rpg_item, [] as Array[String]);
    if (tooltip_strings.is_empty()):
        push_error("Missing tooltip strings for: \"%s\"!" % rpg_item.resource_path);

    return tooltip_strings;

func _update_equipped_display():
    cloak_slot.icon = GlobalPlayer.cloak.icon_override if GlobalPlayer.cloak.icon_override else item_type_icon_dict[GlobalPlayer.cloak.item_type];
    cloak_slot.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.cloak);

    sword_slot.icon = GlobalPlayer.sword.icon_override if GlobalPlayer.sword.icon_override else item_type_icon_dict[GlobalPlayer.sword.item_type];
    sword_slot.tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.sword);

    for i in range(spell_slots.size()):
        spell_slots[i].icon = GlobalPlayer.spells[i].icon_override if GlobalPlayer.spells[i].icon_override else item_type_icon_dict[GlobalPlayer.spells[i].item_type];
        spell_slots[i].tooltip_strings = _get_rpg_item_tooltip(GlobalPlayer.spells[i]);

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
    _update_equippable_display(current_equip_type);

func _ready() -> void:
    _generate_rpg_item_tooltips();

    cloak_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Cloak));
    sword_slot.mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Sword));
    for i in range(spell_slots.size()):
        spell_slots[i].mouse_entered.connect(_update_equippable_display.bind(Enum.RPGItemType.Spell + i));

    _update_equippable_display_container();
    _update_equipped_display();
