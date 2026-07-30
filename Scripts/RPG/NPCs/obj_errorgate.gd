extends RPGInteractable

const dialogue_dict: Dictionary[StringName, DialogueData] = {
    "TEST_SCENE": preload("res://Dialogue/error_demoentity.tres")
};

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE" && GlobalPlayer.get_flag(&"iEvilScore") >= 3 && !GlobalPlayer.get_bool_flag(&"bErrorWorld")):
        if (!GlobalPlayer.get_bool_flag(&"bErrorUnlocked")):
            RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self));
            GlobalPlayer.set_bool_flag(&"bErrorUnlocked", true)
        self._set_collision(false);
