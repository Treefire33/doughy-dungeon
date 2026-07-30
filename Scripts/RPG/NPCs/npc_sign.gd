extends RPGInteractable

const dialogue_dict: Dictionary[StringName, DialogueData] = {
    "TEST_SCENE": preload("res://Dialogue/tutorial_sign.tres"),
    "ERR_WORLD": preload("res://Dialogue/error_demoworld.tres")
};

var error_world: bool = false;
func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == &"ERR_WORLD"): error_world = true;

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    if (error_world && !GlobalPlayer.get_bool_flag(&"bErrorWorld")):
        GlobalPlayer.add_rpg_item(&"ErroneousGlaive");
        GlobalPlayer.set_bool_flag(&"bErrorWorld", true);
    RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self));
