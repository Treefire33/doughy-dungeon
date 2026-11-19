extends Node

signal rpgplayer_valid();
const player_scene: PackedScene = preload("res://Scenes/Prefabs/rpg_player.tscn");
var _scene_list: Dictionary[StringName, PackedScene] = _get_rpg_scenes("res://Scenes/RPG/");

func _get_rpg_scenes(path: String) -> Dictionary[StringName, PackedScene]:
    var scenes_dir = ResourceLoader.list_directory(path);
    var final: Dictionary[StringName, PackedScene] = {};
    for file in scenes_dir:
        if (file.ends_with("/")): 
            final.merge(_get_rpg_scenes(path+file)); 
            continue;
        if (!file.ends_with(".tscn")): continue;

        var packed_scene: PackedScene = ResourceLoader.load(path + file);
        var scene: RPGScene = packed_scene.instantiate() as RPGScene;
        final[scene.scene_id] = packed_scene;
        scene.queue_free();
    return final;

var current_scene_id: StringName;
var player: RPGPlayer = player_scene.instantiate();
    
func move_rooms(destination_id: StringName, entrance_id: int = 0):
    if (!is_instance_valid(player)): player = player_scene.instantiate();
    if (player.get_parent()): player.get_parent().remove_child(player);
    SuperLoader.switch_scene(_scene_list[destination_id]);
    if (SuperLoader.current_scene is not RPGScene): push_error("Destination scene is not an RPGScene!"); return;

    var destination_entrance: Node2D = SuperLoader.current_scene.find_entrance_by_id(entrance_id);
    if (destination_entrance):
        if (!destination_entrance.is_node_ready()): await destination_entrance.ready;
        player.velocity = Vector2.ZERO;
        player.global_position = destination_entrance.entrance_position.global_position;
    else:
        player.global_position = SuperLoader.current_scene.position;
    
    if (!SuperLoader.current_scene.is_node_ready()): await SuperLoader.current_scene.ready;

    SuperLoader.current_scene.add_child(player);
    if (!player.is_node_ready()): await player.ready;
    rpgplayer_valid.emit();
    RPGEventBus.clear_connections();

    current_scene_id = destination_id;
