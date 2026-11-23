extends RPGInteractable

var lana_spells_demo: DialogueResource = preload("res://Dialogue/lana_demo.dialogue");

func _on_room_entered(args: RPGEventBus.RPGRoomEventArgs):
    super(args);
    self.set_enabled(args.scene_id == "TEST_SCENE" && GlobalPlayer.completed_dungeons[Enum.Dungeon.Doughy]);

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    super(args);
    RPGEventBus.fire_event(RPGEventBus.RPGDialogueArgs.new(RPGEventBus.RPGEventId.RPG_Dialogue, self, lana_spells_demo));
