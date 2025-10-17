extends Control
class_name RoomSelect

signal room_decision(decision: Enum.RoomDecision);

@export var room_button: RoomSelectButton;
@export var midnight_icon: TextureRect;
@export var select_camera: Camera2D;
@export var selection_inspect: Panel;
@export var size_bound: int;
var selection_title: RichTextLabel;
var selection_description: RichTextLabel;
var selection_accept: Button;

@export var room_count: RichTextLabel;
@export var floor_count: RichTextLabel;
@export var dungeon_name_label: RichTextLabel;
enum Direction {
	Left = 0, Up = 1,
	Down = 2, Right = 3
}
var directions: Array[Direction] = [Direction.Left, Direction.Right, Direction.Down, Direction.Up];
var last_buttons: Array[RoomSelectButton] = [];

func invert_direction(current_direction: Direction):
	match (current_direction):
		Direction.Left:
			return Direction.Right;
		Direction.Up:
			return Direction.Down;
		Direction.Down:
			return Direction.Up;
		Direction.Right:
			return Direction.Left;

var selected_room: RoomSelectButton = null;
var current_room: RoomSelectButton = null;
var descriptions = {
	Enum.RoomDecision.Proceed: ["Proceed", "This room seems to follow the beaten path, the safest."],
	Enum.RoomDecision.RiskIt: ["Risk It", "This room is infested with higher tier enemies, but it could mean better rewards."],
	Enum.RoomDecision.StayClear: ["Stay Clear", "Sneak past a room and advance to one after it. Next room is harder."]
}
func inspect_room(room: RoomSelectButton):
	midnight_icon.position = room.position + ((room.size / 2) - (midnight_icon.size / 2));
	select_camera.position = midnight_icon.position + Vector2(selection_inspect.size.x / 2, 0);
	selection_inspect.visible = true;
	selection_title.text = descriptions[room.room_type][0];
	selection_description.text = descriptions[room.room_type][1];
	selected_room = room;

func select_room():
	if (selected_room == null):
		return
	current_room.modulate = Color(1, 1, 1, 0.5);
	last_buttons.erase(selected_room);
	current_room = selected_room;
	selected_room = null;
	room_decision.emit(current_room.room_type);
	self.visible = false;

func generate_rooms(room: RoomSelectButton):
	var possible_directions = directions.filter(func(type):
		return type != room.previous_direction
	);
	var possible_room_types: Array[Enum.RoomDecision] = [Enum.RoomDecision.Proceed, Enum.RoomDecision.StayClear, Enum.RoomDecision.RiskIt];

	for button in last_buttons:
		button.queue_free();
	last_buttons.clear();

	for i in range(3):
		var current_direction = possible_directions.pick_random();
		var new_room_button: RoomSelectButton = room_button.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS);
		current_room.add_sibling(new_room_button);
		var room_size = randi_range(1, size_bound) * 64;
		new_room_button.position = room.position;
		match current_direction:
			Direction.Left:
				new_room_button.size.x = room_size;
				new_room_button.position.x -= new_room_button.size.x;
			Direction.Right:
				new_room_button.size.x = room_size;
				new_room_button.position.x += room.size.x;
			Direction.Up:
				new_room_button.size.y = room_size;
				new_room_button.position.y -= new_room_button.size.y;
			Direction.Down:
				new_room_button.size.y = room_size;
				new_room_button.position.y += room.size.y;
		new_room_button.previous_direction = invert_direction(current_direction);
		possible_directions.erase(current_direction);
		new_room_button.room_type = possible_room_types.pick_random();
		possible_room_types.erase(new_room_button.room_type);
		match (new_room_button.room_type):
			Enum.RoomDecision.Proceed:
				new_room_button.text = "+"
			Enum.RoomDecision.RiskIt:
				new_room_button.text = "x"
			Enum.RoomDecision.StayClear:
				new_room_button.text = "o"
		new_room_button.pressed.connect(inspect_room.bind(new_room_button));
		last_buttons.append(new_room_button);
	last_buttons.sort_custom(func(a, b):
		return invert_direction(a.previous_direction) < invert_direction(b.previous_direction);
	);
	current_room.disabled = true;

func _ready() -> void:
	selection_title = selection_inspect.get_node("RoomType");
	selection_description = selection_inspect.get_node("RoomDescription");
	selection_accept = selection_inspect.get_node("Proceed");
	selection_accept.pressed.connect(select_room);

	current_room = room_button;
	selected_room = current_room;
	room_button = room_button.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS);

func request_room(room_count_num, floor_count_mod, dungeon_name):
	self.visible = true;
	room_count.text = "ROOM: %d" % room_count_num;
	floor_count.text = "FLOOR: %d" % (int(room_count_num / floor_count_mod) + 1);
	dungeon_name_label.text = dungeon_name;
	if (room_count_num % floor_count_mod == 0):
		for button in current_room.get_parent().get_children():
			if (button is Button && button != current_room):
				button.queue_free();
	generate_rooms(current_room);

var directional_actions = [
	"Up", "Down", "Left", "Right"
];
func _input(event: InputEvent) -> void:
	if (!self.visible):
		return;

	if (selected_room != null && Input.is_action_just_pressed("Primary")):
		selection_accept.pressed.emit();

	var direction: int = -1;
	for action in directional_actions:
		if (Input.is_action_just_pressed(action)):
			direction = invert_direction(Direction.get(action));
	
	if (direction == -1):
		return;
	
	for button in last_buttons:
		if (button.previous_direction == direction):
			button.pressed.emit();
