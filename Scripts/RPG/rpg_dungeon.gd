extends RPGInteractable
class_name RPGDungeon

@export var dungeon: DungeonData;

func _ready() -> void:
    super();
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_EnterDungeon, func(args: RPGEventBus.RPGInteractionArgs):
        if (args.interaction_object != self): return;
        GlobalPlayer.current_dungeon = dungeon;
    );

func _on_interaction(args: RPGEventBus.RPGInteractionArgs):
    if (args.interaction_object != self): return;
    RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_InpsectDungeon, self));

