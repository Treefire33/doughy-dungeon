extends Control
class_name RoomSelect

signal room_decision(decision: Enum.RoomDecision);

@export var room_button: RoomSelectButton;
@export var midnight_icon: TextureRect;
@export var select_camera: Camera2D;
@export var selection_inspect: Panel;
@export var size_bound: int;
@export var room_count: RichTextLabel;
@export var floor_count: RichTextLabel;
@export var dungeon_name_label: RichTextLabel;

var rng: RandomNumberGenerator = RandomNumberGenerator.new();

var selection_title: RichTextLabel;
var selection_description: RichTextLabel;
var selection_accept: Button;

var current_room: RoomSelectButton = null;
var selected_room: RoomSelectButton = null;
var rooms: Array[RoomSelectButton] = [];

func invert_direction(current_direction: Enum.Direction):
    match (current_direction):
        Enum.Direction.Left:
            return Enum.Direction.Right;
        Enum.Direction.Up:
            return Enum.Direction.Down;
        Enum.Direction.Down:
            return Enum.Direction.Up;
        Enum.Direction.Right:
            return Enum.Direction.Left;

func get_random_room(room_pool: Array[RoomData], difficulty: int) -> RoomData:
    var possible_rooms = [];
    var weights = [];
    for room in room_pool:
        if (difficulty < room.minimum_difficulty || difficulty > room.maximum_difficulty):
            continue;
        possible_rooms.append(room);
        weights.append(room.room_weight);
    
    return possible_rooms[rng.rand_weighted(weights)];

func generate_room(room_pool: Array[RoomData], difficulty: int) -> RoomSelectButton:
    var new_room_button: RoomSelectButton = room_button.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS);
    var selected_room_data: RoomData = get_random_room(room_pool, difficulty);

    new_room_button.room_data = selected_room_data;
    return new_room_button;

func get_direction_offset(direction: Enum.Direction, room_button: RoomSelectButton) -> Vector2:
    var offset: Vector2 = Vector2.ZERO;
    match (direction):
        Enum.Direction.Left:
            offset = Vector2(-1, 0);
        Enum.Direction.Right:
            offset = Vector2(1, 0);
        Enum.Direction.Up:
            offset = Vector2(0, 1);
        Enum.Direction.Down:
            offset = Vector2(0, -1);
        Enum.Direction.None:
            offset = Vector2(0, 0);
    return offset * room_button.size;

func position_occupied(room: RoomSelectButton, position: Vector2) -> bool:
    return position == room.position;

func generate_room_bunch(room_button: RoomSelectButton, room_pool: Array[RoomData], difficulty: int, room_depth: int) -> void:
    if (room_depth <= 0): return;

    var possible_directions = directions.filter(func(type):
        return type != room_button.room_direction
    );
    var next_functions: Array[Callable] = [];
    for i in range(3):
        var new_room = generate_room(room_pool, difficulty);
        var selected_direction = possible_directions.pick_random();
        var new_position = room_button.position + get_direction_offset(selected_direction, room_button);
        possible_directions.remove_at(possible_directions.find(selected_direction));

        var possible_cover_room = rooms.find_custom(position_occupied.bind(new_position));          
        if (possible_cover_room > -1):
            var room = rooms[possible_cover_room];
            if (!current_room.next_rooms.has(room)):
                room_button.next_rooms.append(room);
            continue;
        
        new_room.room_direction = selected_direction;
        new_room.position = new_position;
        match (new_room.room_data.room_type):
            Enum.RoomDecision.Proceed:
                new_room.text = "+";
            Enum.RoomDecision.RiskIt:
                new_room.text = "x";
            Enum.RoomDecision.StayClear:
                new_room.text = "o";
        new_room.pressed.connect(inspect_room.bind(new_room));
        room_button.add_sibling(new_room);
        room_button.next_rooms.append(new_room);
        rooms.append(new_room);
        next_functions.append(generate_room_bunch.bind(new_room, room_pool, difficulty, room_depth - new_room.room_data.room_length));
    
    for function in next_functions:
        function.call();

var directions: Array[Enum.Direction] = [Enum.Direction.Left, Enum.Direction.Up, Enum.Direction.Right, Enum.Direction.Down];
func generate_floor(rooms_per_floor: int, room_pool: Array[RoomData], difficulty: int) -> void:
    generate_room_bunch(current_room, room_pool, difficulty, rooms_per_floor - 1);

func request_floor(rooms_per_floor: int, room_pool: Array[RoomData], difficulty: int):
    for button in current_room.get_parent().get_children():
        if (button is not Button || button == current_room): continue;
        button.queue_free();
    rooms.clear();
    rooms.append(current_room);
    generate_floor(rooms_per_floor, room_pool, difficulty);

func request_room(room_number: int, floor_count_mod: int, dungeon_name: String):
    selection_inspect.visible = false;
    for button in rooms:
        button.disabled = !(current_room.next_rooms.has(button) || current_room == button);
    self.visible = true;
    room_count.text = "ROOM: %d" % room_number;
    @warning_ignore("integer_division")
    floor_count.text = "FLOOR: %d" % (int(room_number / floor_count_mod) + 1);
    dungeon_name_label.text = dungeon_name;

func inspect_room(room: RoomSelectButton):        
    midnight_icon.position = room.position + ((room.size / 2) - (midnight_icon.size / 2));
    select_camera.position = midnight_icon.position + Vector2(selection_inspect.size.x / 2, 0);
    if (room == current_room): 
        selection_inspect.visible = false;
        return;
    selection_inspect.visible = true;
    selection_title.text = room.room_data.room_name;
    selection_description.text = room.room_data.room_description;
    selected_room = room;

func select_room():
    if (selected_room == null): return;
    current_room.modulate = Color(1, 1, 1, 0.5);
    current_room = selected_room;
    selected_room = null;
    room_decision.emit(current_room.room_type);
    self.visible = false;

func _ready() -> void:
    selection_title = selection_inspect.get_node("RoomType");
    selection_description = selection_inspect.get_node("RoomDescription");
    selection_accept = selection_inspect.get_node("Proceed");
    selection_accept.pressed.connect(select_room);

    current_room = room_button;
    current_room.pressed.connect(inspect_room.bind(current_room));
    rooms.append(current_room);
    room_button = room_button.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS);
