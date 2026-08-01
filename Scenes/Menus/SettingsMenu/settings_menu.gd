extends Control
class_name SettingsMenu

@export var settings_done: Button;
@export var categories: Dictionary[StringName, Control];
@export var setting_prototype: PackedScene;

func _generate_setting_property(setting_name: StringName):
    var setting_dict = Settings.get_setting_dict(setting_name);
    var setting_category = setting_dict.get(&"category");
    var setting_type: int = setting_dict.get(&"type");
    var setting_value: Variant = setting_dict.get(&"value");
    var setting_variant: StringName = setting_dict.get(&"type_variant", &"non_variant");
    var setting_tooltip: String = setting_dict.get(&"tooltip");

    assert(setting_category != null);
    assert(setting_type != null && setting_type is Variant.Type);
    assert(setting_value != null && typeof(setting_value) == setting_type);

    var new_setting_prototype: Control = setting_prototype.instantiate();
    var setting_name_label: RichTextLabel = new_setting_prototype.get_node("Name");
    var setting_tooltip_trigger: TooltipTrigger = setting_name_label.get_node("TooltipTrigger");
    var setting_display_name: String = setting_dict.get(&"name", setting_name);
    new_setting_prototype.name = setting_display_name;
    setting_name_label.text = setting_display_name.to_upper() + ":";
    
    match (setting_type):
        TYPE_INT, TYPE_FLOAT:
            if (setting_variant != null && setting_variant.contains("range")):
                var setting_min_value = setting_dict.get(&"min_value", 0);
                var setting_max_value = setting_dict.get(&"max_value", 100);
                var setting_value_step = setting_dict.get(&"step", 0);
                var setting_range: Range = new_setting_prototype.get_node("NumberValue") if setting_variant == &"range_spin" else new_setting_prototype.get_node("SliderValue");
                
                setting_range.min_value = setting_min_value;
                setting_range.max_value = setting_max_value;
                setting_range.step = setting_value_step;
                setting_range.value = setting_value;
                setting_range.value_changed.connect(func(value):
                    if (setting_type == TYPE_INT):
                        value = int(value);
                    Settings.set_setting_value(setting_name, value);
                );
                setting_range.visible = true;
            elif (setting_variant != null && setting_variant == &"options"):
                var setting_dropdown: OptionButton = new_setting_prototype.get_node("OptionValue");
                var setting_options: Array = setting_dict.get(&"options");
                assert(setting_options != null);
                for option in setting_options:
                    assert(typeof(option) == TYPE_ARRAY);
                    var option_index: int = option[0];
                    var option_name: String = option[1];
                    setting_dropdown.add_item(option_name, option_index);
                setting_dropdown.select(setting_value);
                setting_dropdown.item_selected.connect(func(idx: int):
                    Settings.set_setting_value(setting_name, idx);
                );
                setting_dropdown.visible = true;
        
        TYPE_BOOL:
            var setting_checkbox: MidnightCheckbox = new_setting_prototype.get_node("BoolValue");
            setting_checkbox.set_pressed_no_signal(setting_value);
            setting_checkbox.toggled.connect(func(toggled: bool):
                Settings.set_setting_value(setting_name, toggled);
            );
            setting_checkbox.visible = true;
        
        TYPE_STRING:
            if (setting_variant != null && setting_variant == &"language"):
                var setting_dropdown: OptionButton = new_setting_prototype.get_node("OptionValue");
                var i: int = 0;
                for language in TranslationServer.get_loaded_locales():
                    language_list.insert(i, language);
                    setting_dropdown.add_item("%s (%s)" % [ TranslationServer.get_language_name(language.split('_')[0]), language ], i);
                    if (Settings.language == language): setting_dropdown.select(i);
                    i += 1;
                setting_dropdown.visible = true;
                setting_dropdown.item_selected.connect(func(idx: int):
                    Settings.set_setting_value(setting_name, language_list[idx]);
                );
        
        TYPE_CALLABLE:
            var setting_button: Button = new_setting_prototype.get_node("CallableValue");
            var callable_name: String = setting_dict.get("callable_name", "_MISSING_CALLABLE_NAME");
            setting_button.text = callable_name;
            setting_button.pressed.connect(func():
                setting_value.call(self.get_parent());
            );
            setting_button.visible = true;
    
    var category: Control = categories.get(setting_category);
    category.add_child(new_setting_prototype);
    if (setting_tooltip.is_empty()):
        setting_tooltip_trigger.queue_free();
        return;
    setting_tooltip_trigger.tooltip_strings = [
        setting_tooltip
    ];

var language_list: Array[StringName] = [];
func _ready():
    for setting_name in Settings.settings_dict:
        _generate_setting_property(setting_name);
    
    settings_done.grab_focus();
    settings_done.pressed.connect(func():
        queue_free();
    );
