@tool
extends EditorPlugin

var resource_translator;

func _enter_tree() -> void:
    resource_translator = load("res://addons/midnight_resource_translator/resource_translator.gd").new();
    add_translation_parser_plugin(resource_translator);

func _exit_tree() -> void:
    if (is_instance_valid(resource_translator)):
        remove_translation_parser_plugin(resource_translator);
        resource_translator = null;
