extends Node

signal rpgplayer_valid();
const player_scene: PackedScene = preload("res://Scenes/Prefabs/rpg_player.tscn");
var _scene_list: Dictionary[StringName, PackedScene] = {
    &"INTRO": preload("res://Scenes/RPG/rpg_intro.tscn"),
    &"INTRO_B": preload("res://Scenes/RPG/rpg_intro_b.tscn"),
    &"TEST_SCENE": preload("res://Scenes/rpg_test.tscn"),
    &"ERR_WORLD": preload("res://Scenes/RPG/rpg_error_entity_world.tscn")
};

var current_scene_id: StringName;
var player: RPGPlayer = player_scene.instantiate();

func move_rooms(destination_id: StringName, entrance_id: int = 0):
    if (!is_instance_valid(player)): player = player_scene.instantiate();
    if (player.get_parent()): player.get_parent().remove_child(player);
    SuperLoader.switch_scene(_scene_list[destination_id]);
    if (SuperLoader.current_scene is not RPGScene): push_error("Destination scene is not an RPGScene!"); return;
    SuperLoader.current_scene.add_child(player);
    rpgplayer_valid.emit();
    RPGEventBus.clear_connections();
    var destination_entrance: Node2D = SuperLoader.current_scene.find_entrance_by_id(entrance_id);
    if (destination_entrance):
        await destination_entrance.ready;
        if (!player.is_node_ready()): await player.ready;
        player.velocity = Vector2.ZERO;
        player.global_position = destination_entrance.entrance_position.global_position;
    else:
        player.global_position = SuperLoader.current_scene.position;
    current_scene_id = destination_id;
