extends RPGInteractable

var afternoon_secret: DialogueResource = preload("res://Dialogue/afternoon_secret.dialogue");

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE" && !GlobalPlayer.get_bool_flag(&"bMetAfternoon")):
        var is_existing: bool = randi_range(0, 100) <= 10;
        self.set_enabled(is_existing);

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, afternoon_secret));
