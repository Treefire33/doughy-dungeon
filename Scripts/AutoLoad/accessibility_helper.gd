extends Node

var keybind_helper: PackedScene = preload("res://Scenes/Prefabs/keybind_notifier.tscn");
var current_keybind_helpers: Dictionary[String, Array] = {};

func _ready() -> void:
    Keybinds.keybind_changed.connect(update_action_binds);

func update_binds():
    for action in current_keybind_helpers:
        update_action_binds(action);

func update_action_binds(action_name: String):
    current_keybind_helpers[action_name] = current_keybind_helpers[action_name].filter(func(helper): return helper != null);
    for helper: Control in current_keybind_helpers[action_name]:
        helper.visible = Settings.helpers_enabled;
        helper.get_node("Keybind").text = Keybinds.get_action_text(action_name);
        helper.get_node("Keybind").horizontal_alignment = Settings.helper_alignment;

func make_keybind_helper(node: Control, action_name: String):
    var new_helper: Control = keybind_helper.instantiate();
    node.add_child(new_helper);
    new_helper.name = "KeybindHelper";
    if (!current_keybind_helpers.has(action_name)): current_keybind_helpers[action_name] = [];
    current_keybind_helpers[action_name].append(new_helper);

    update_action_binds(action_name);

func remove_keybind_helper(node: Control):
    var helper = node.get_node("KeybindHelper");
    helper.queue_free();
