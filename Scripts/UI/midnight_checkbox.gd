@tool
extends Button
class_name MidnightCheckbox

@export var check_texture: Texture2D = load("res://Sprites/Other/checkmark.aseprite"):
    set(value):
        check_texture = value;
        queue_redraw();

func _init() -> void:
    self.toggle_mode = true;

func _draw() -> void:
    if (!self.button_pressed): return;
    var rect = Rect2(
        Vector2(2, 2),
        self.size - Vector2(4, 4)
    );
    draw_texture_rect(check_texture, rect, false);

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        queue_redraw();
