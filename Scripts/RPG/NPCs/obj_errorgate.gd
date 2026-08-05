extends RPGInteractable

var entrance_dialogue: DialogueResource = preload("res://Dialogue/error_demoentity.dialogue");

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE" && GlobalPlayer.get_flag(&"iEvilScore") >= 3 && !GlobalPlayer.get_bool_flag(&"bErrorWorld")):
        if (!GlobalPlayer.get_bool_flag(&"bErrorUnlocked")):
            RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, entrance_dialogue));
            GlobalPlayer.set_bool_flag(&"bErrorUnlocked", true);
        self._set_collision(false);
