extends Node2D
class_name RPGScene

@export var scene_id: StringName = "";
@export var entrances: Array[RPGRoomTrigger] = [];
@export var camera_limits: TileMapLayer;

func find_entrance_by_id(entrance_id: int) -> RPGRoomTrigger:
    var index = entrances.find_custom(func(entrance: RPGRoomTrigger):
        return entrance.entrance_id == entrance_id;
    );
    return entrances[index] if index != -1 else null;

func _on_entered(args: RPGEventBus.RPGRoomEventArgs):
    pass;

func _ready() -> void:
    var limits_rect = camera_limits.get_used_rect();
    var limit_topleft = limits_rect.position * camera_limits.tile_set.tile_size;
    var limit_bottomright = limits_rect.end * camera_limits.tile_set.tile_size;
    if (!is_instance_valid(RPGManager.player)): await RPGManager.rpgplayer_valid;
    if (!RPGManager.player.is_node_ready()): await RPGManager.player.ready;
    RPGManager.player.camera.limit_top = limit_topleft.y;
    RPGManager.player.camera.limit_left = limit_topleft.x;
    RPGManager.player.camera.limit_bottom = limit_bottomright.y;
    RPGManager.player.camera.limit_right = limit_bottomright.x;
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_RoomEntered, _on_entered);
    RPGEventBus.fire_event(RPGEventBus.RPGRoomEventArgs.new(RPGEventBus.RPGEventId.RPG_RoomEntered, self.scene_id));

func _exit_tree() -> void:
    RPGEventBus.fire_event(RPGEventBus.RPGRoomEventArgs.new(RPGEventBus.RPGEventId.RPG_RoomExited, self.scene_id));
