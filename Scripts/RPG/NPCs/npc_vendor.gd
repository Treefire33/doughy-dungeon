extends RPGInteractable

var vendor_beta: DialogueData = preload("res://Dialogue/vendor_beta.tres");

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    if (args.scene_id == "TEST_SCENE"):
        self.visible = GlobalPlayer.get_flag(&"bVendorMet");
        self._set_collision(GlobalPlayer.get_flag(&"bVendorMet"));

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, vendor_beta));
