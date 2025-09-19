extends Control
class_name KeybindButton

@onready var inner_button: Button = $Button;
@export var keybinds_menu: KeybindsMenu;
var associated_keybind: String = "Pause";

func _ready() -> void:
	inner_button.pressed.connect(func():
		keybinds_menu.set_keybind(associated_keybind);
	);

func _process(delta: float) -> void:
	inner_button.text = Keybinds.get_action_text(associated_keybind);
