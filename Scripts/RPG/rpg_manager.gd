extends Node

var _scene_list: Dictionary[StringName, PackedScene] = {
    &"TEST_SCENE": preload("res://Scenes/rpg_test.tscn"),
    &"ERR_WORLD": preload("res://Scenes/RPG/rpg_error_entity_world.tscn")
};

var current_scene_id: StringName;
var player: RPGPlayer = preload("res://Scenes/Prefabs/rpg_player.tscn").instantiate();

func move_rooms(destination_id: StringName, entrance_id: int = 0):
    if (player.get_parent()): player.get_parent().remove_child(player);
    SuperLoader.switch_scene(_scene_list[destination_id]);
    if (SuperLoader.current_scene is not RPGScene): push_error("Destination scene is not an RPGScene!"); return;
    SuperLoader.current_scene.add_child(player);
    RPGEventBus.clear_connections();
    var destination_entrance: Node2D = SuperLoader.current_scene.find_entrance_by_id(entrance_id);
    if (destination_entrance):
        await destination_entrance.ready;
        player.global_position = destination_entrance.entrance_position.position;
    else:
        player.global_position = SuperLoader.current_scene.position;
    current_scene_id = destination_id;
