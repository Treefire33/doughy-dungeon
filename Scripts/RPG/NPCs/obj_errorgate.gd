extends RPGInteractable

const dialogue_dict: Dictionary[StringName, DialogueData] = {
    "TEST_SCENE": preload("res://Dialogue/error_demoentity.tres")
};

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE" && GlobalPlayer.grounds_for_evil >= 3):
        if (!GlobalPlayer.error_unlocked):
            RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self));
            GlobalPlayer.error_unlocked = true;
        self._set_collision(false);
