extends Camera2D
@export var zoom_power: float = 0.5;
@export_range(0.001, 100) var zoom_bounds: Array[float] = [0.1, 10];

func _input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture || event is InputEventMouseButton:
		var zoomFactor = Vector2.ONE * event.factor;
		if (event.button_index):
			if (event.button_index < MOUSE_BUTTON_WHEEL_UP || event.button_index > MOUSE_BUTTON_WHEEL_DOWN):
				return;
			if (
				event.button_index == MOUSE_BUTTON_WHEEL_DOWN
			):
					zoomFactor = -zoomFactor;
		self.zoom = (self.zoom + (zoomFactor * zoom_power)).clampf(zoom_bounds[0], zoom_bounds[1]);
	elif event is InputEventScreenDrag || event is InputEventMouseMotion:
		if (!Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			return;
		self.position -= event.screen_relative / self.zoom;
