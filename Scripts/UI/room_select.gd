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
@export var room_button_container: Control;

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

func generate_room_object(room_pool: Array[RoomData], difficulty: int) -> RoomSelectButton:
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
            offset = Vector2(0, -1);
        Enum.Direction.Down:
            offset = Vector2(0, 1);
        Enum.Direction.None:
            offset = Vector2(0, 0);
    return offset * room_button.size;

func position_occupied(room: RoomSelectButton, position: Vector2) -> bool:
    return position == room.position;

var directions: Array[Enum.Direction] = [Enum.Direction.Left, Enum.Direction.Up, Enum.Direction.Right, Enum.Direction.Down];
func generate_room(last_room: RoomSelectButton, room_pool: Array[RoomData], difficulty: int, direction: Enum.Direction, room_depth: int) -> bool:
    # Initial cost guard
    if (room_depth <= 0): return true;

    # Generate room and position it
    var new_room: RoomSelectButton = generate_room_object(room_pool, difficulty);
    var possible_directions = directions.duplicate().filter(func(dir: Enum.Direction): return dir != direction);
    if (rng.randi_range(1, 99) >= 87):
        direction = possible_directions.pick_random();
    
    # Check if a room is already in this position
    var possible_cover_room = 0;
    var iters = 0;
    while (possible_cover_room > -1 && possible_directions.size() > 0 && iters <= 100):
        # print(possible_directions.size());
        new_room.position = last_room.position + get_direction_offset(direction, new_room);
        possible_cover_room = rooms.find_custom(position_occupied.bind(new_room.position));
        possible_directions = possible_directions.filter(func(dir: Enum.Direction): return dir != direction);
        iters += 1;
    
    # In the event we exhausted all possible directions, terminate node
    if (possible_directions.size() == 0 || iters > 100):
        # print("iter fail: ", iters > 100);
        new_room.queue_free();
        return false;
    
    # Add room to rooms for position checking
    rooms.append(new_room);
    var index = rooms.size() - 1;

    # # Random check for branching
    # if (rng.randi_range(1, 99) >= 67):
    #     # Iterate over all possible directions, attempt room generation
    #     for possible_dir in directions.filter(func(dir: Enum.Direction): return dir != direction):
    #         generate_room(new_room, room_pool, difficulty, possible_dir, room_depth - 1);

    if (!generate_room(new_room, room_pool, difficulty, direction, room_depth - 1)):
        new_room.queue_free();
        rooms.remove_at(index);
        return false;
    
    new_room.room_direction = direction;
    new_room.text = new_room.room_data.room_character;
    new_room.pressed.connect(inspect_room.bind(new_room));
    last_room.next_rooms.append(new_room);
    room_button_container.add_child(new_room);

    return true;

func generate_floor(rooms_per_floor: int, room_pool: Array[RoomData], difficulty: int) -> void:
    for i in range(4):
        generate_room(current_room, room_pool, difficulty, i as Enum.Direction, rooms_per_floor - 1);

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
        if (button == current_room): button.modulate = Color(1, 1, 1, 0.75); # current room
        elif (button.visited): button.modulate = Color(1, 1, 1, 0.65); # visited
        elif (button.disabled): button.modulate = Color(1, 1, 1, 0.45); # too far/unvisited
        else: button.modulate = Color(1, 1, 1, 1); # visible rooms

    self.visible = true;
    room_count.text = "ROOM: %d" % room_number;
    @warning_ignore("integer_division")
    floor_count.text = "FLOOR: %d" % (int(room_number / floor_count_mod) + 1);
    dungeon_name_label.text = dungeon_name;

func inspect_room(room: RoomSelectButton):    
    if (room.visited): return;    
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
    current_room.visited = true;
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
    current_room.room_data = RoomData.default_rooms[0];
    current_room.pressed.connect(inspect_room.bind(current_room));
    rooms.append(current_room);
    room_button = room_button.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS);

var direction_action_dict: Dictionary[Enum.Direction, String] = {
    Enum.Direction.Left: "Left",
    Enum.Direction.Up: "Up",
    Enum.Direction.Right: "Right",
    Enum.Direction.Down: "Down"
};
func _input(event: InputEvent) -> void:
    if (!event is InputEventKey): return;
    if (!self.visible): return;

    if (selected_room != null && Input.is_action_just_pressed("Primary")):
        selection_accept.pressed.emit();
    
    for direction in direction_action_dict.keys():
        if (!Input.is_action_pressed(direction_action_dict[direction])): continue;
        var possible_room: RoomSelectButton = null;
        for room in current_room.next_rooms:
            match (direction):
                Enum.Direction.Left:
                    if (room.position.x < current_room.position.x): possible_room = room; break;
                Enum.Direction.Right:
                    if (room.position.x > current_room.position.x): possible_room = room; break;
                Enum.Direction.Down:
                    if (room.position.y > current_room.position.y): possible_room = room; break;
                Enum.Direction.Up:
                    if (room.position.y < current_room.position.y): possible_room = room; break;
        if (!possible_room): continue;
        possible_room.pressed.emit();
