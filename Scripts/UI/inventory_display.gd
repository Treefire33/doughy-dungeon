extends Control
class_name InventoryDisplay

# Inventory
@onready var inventory_item: TextureRect = $Panel/Item;
@onready var inventory_items: Container = $Panel/Scroll/ItemsContainer;

# Stats
@onready var stats_panel: Control = $Panel;
@onready var room_difficulty: RichTextLabel = $Panel/RoomStats/Difficulty;
@onready var room_multiplier: RichTextLabel = $Panel/RoomStats/Multiplier;

func load_inventory(room_manager: RoomManager):
    self.visible = !self.visible;
    if (!self.visible): return;

    for child in inventory_items.get_children():
        child.queue_free()

    for item in room_manager.player.items:
        var count = room_manager.player.items[item];
        var data = ItemUtils.get_item_data(item);
        var new_item = inventory_item.duplicate();
        var item_tooltip: TooltipTrigger = new_item.get_node("Button");
        new_item.visible = true;
        item_tooltip.tooltip_strings.append_array(ItemUtils.get_tooltip_text(data, false, room_manager.player));
        new_item.get_node("Count").text = str(count);
        new_item.play(ItemUtils.get_item_animation_name(data));
        inventory_items.add_child(new_item);
        
func load_stats(room_manager: RoomManager, in_safe_room: bool):
    if (!self.visible): return;
    room_difficulty.text = "ROOM DIFFICULTY: %s" % str(room_manager.room_difficulty);
    room_multiplier.text = "ROOM MULTIPLIER: %s" % str(room_manager.room_multiplier);
    
func update(room_manager: RoomManager, in_safe_room: bool):
    load_inventory(room_manager);
    load_stats(room_manager, in_safe_room);
