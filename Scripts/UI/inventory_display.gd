extends Control
class_name InventoryDisplay

# Inventory
@onready var inventory_item: TextureRect = $Items/Item;
@onready var inventory_items: GridContainer = $Items/Scroll/ItemsContainer;

# Stats
@onready var stats_panel: ColorRect = $Upgrades;
@onready var room_difficulty: RichTextLabel = $Upgrades/Difficulty;
@onready var room_multiplier: RichTextLabel = $Upgrades/Multiplier;

func load_inventory(room_manager: RoomManager):
	self.visible = !self.visible;
	if (!self.visible): return;

	for child in inventory_items.get_children():
		child.queue_free()

	for item in room_manager.player.items:
		var count = room_manager.player.items[item];
		var data = ItemUtils.get_item_data(item);
		var new_item = inventory_item.duplicate();
		new_item.visible = true;
		new_item.get_node("Button").tooltip_text = item + \
		"\n" + data.flavour_text + "\n\n" + data.description;
		new_item.get_node("Count").text = str(count)
		new_item.texture = data.sprite;
		inventory_items.add_child(new_item)
		
func load_stats(room_manager: RoomManager, in_safe_room: bool):
	if (!self.visible): return;
	stats_panel.visible = !in_safe_room;
	room_difficulty.text = "ROOM DIFFICULTY: %s" % str(room_manager.room_difficulty);
	room_multiplier.text = "ROOM MULTIPLIER: %s" % str(room_manager.room_multiplier);
	
func update(room_manager: RoomManager, in_safe_room: bool):
	load_inventory(room_manager);
	load_stats(room_manager, in_safe_room);
