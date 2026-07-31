extends RPGInteractable

var tutorial_sign_dialogue: DialogueData = preload("res://Dialogue/tutorial_sign.tres");
var error_world_dialogue: DialogueData = preload("res://Dialogue/error_demoworld.tres");
var error_world_dialogue_talked: DialogueData = preload("res://Dialogue/error_demoworld_talked.tres");

var scene_id: StringName;
func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    scene_id = args.scene_id;

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    if (scene_id == &"ERR_WORLD" && !GlobalPlayer.get_bool_flag(&"bErrorWorld")):
        GlobalPlayer.add_rpg_item(&"ErroneousGlaive");
        GlobalPlayer.set_bool_flag(&"bErrorWorld", true);
        RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, error_world_dialogue));
    elif (scene_id == &"ERR_WORLD"):
        RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, error_world_dialogue_talked));
    elif (scene_id == &"TEST_SCENE"):
        RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, tutorial_sign_dialogue));
