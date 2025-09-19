extends Control
class_name KeybindsMenu

signal get_key;

@onready var setting_keybind_popup: Panel = $SettingKeybind;
@onready var setting_keybind_button: Button = $SettingKeybind/CancelKey;
@onready var keybinds_container: GridContainer = $ScrollContainer/KeybindsContainer;
@onready var bind_preset: Control = $BindPreset;
@onready var keybinds_done: Button = $Done;

var setting_key: bool = false;

func set_keybind(associated_keybind: String):
	setting_key = true;
	setting_keybind_popup.show();
	var key = await get_key;
	if (key == null):
		setting_keybind_popup.hide();
		setting_key = false;
		return;
	Keybinds.remap_action(associated_keybind, key);
	setting_keybind_popup.hide();
	setting_key = false;
	
func _input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if (!event.pressed):
			return;
		if (!setting_key):
			return;
		
		get_key.emit(event);

func _ready() -> void:
	for action in InputMap.get_actions():
		if (not Keybinds.bindable_actions.has(action)):
			continue;
		var new_bind = bind_preset.duplicate();
		new_bind.show();
		new_bind.get_node("KeybindName").text = "%s:" % action;
		new_bind.get_node("KeybindName").tooltip_text = Keybinds.get_action_description(action);
		new_bind.get_node("Bind").associated_keybind = action;
		keybinds_container.add_child(new_bind);
	
	setting_keybind_button.pressed.connect(func():
		get_key.emit(null);
	)
	keybinds_done.pressed.connect(func():
		self.queue_free();
	)
