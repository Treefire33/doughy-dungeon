extends Button
class_name RoomSelectButton

var visited: bool = false;

var room_direction: Enum.Direction = Enum.Direction.None;
var room_data: RoomData = null;
var next_rooms: Array[RoomSelectButton] = [];
var room_type: Enum.RoomDecision:
    get: return self.room_data.room_type;
