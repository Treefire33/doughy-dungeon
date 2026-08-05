extends RPGInteractable

var tutorial_sign_dialogue: DialogueResource = preload("res://Dialogue/tutorial_sign.dialogue");
var error_world_dialogue: DialogueResource = preload("res://Dialogue/error_demoworld.dialogue");

var scene_id: StringName;
func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    scene_id = args.scene_id;

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    if (scene_id == &"ERR_WORLD"):
        RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, error_world_dialogue));
    if (scene_id == &"TEST_SCENE"):
        RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, tutorial_sign_dialogue));
