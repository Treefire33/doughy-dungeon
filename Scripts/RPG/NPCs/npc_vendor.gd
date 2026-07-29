extends RPGInteractable

const dialogue_dict: Dictionary[StringName, DialogueData] = {
    "TEST_SCENE": preload("res://Dialogue/vendor_beta.tres")
};

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE" && !GlobalPlayer.met_vendor):
        self.visible = false;
        self._set_collision(false);

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self));
