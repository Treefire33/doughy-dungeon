extends Control
class_name Tooltip

static var tooltip_template: PackedScene = preload("res://Scenes/GameUI/tooltip.tscn");

var text: String = "":
    get: return text;
    set(value):
        if (!self.is_node_ready()): return;
        text = value;
        queue_redraw();

var default_line_size: int = 12;
var padding: Vector2 = Vector2(32, 32);
var max_size: Vector2i = Vector2i(280, 200);
var locked: bool = false;

@onready var text_container: VBoxContainer = $TextContainer;

func _create_text_label(label_text: String, size: int = default_line_size) -> RichTextLabel:
    var new_label = RichTextLabel.new();
    new_label.fit_content = true;
    new_label.add_theme_font_size_override("normal_font_size", size);
    new_label.text = label_text;
    return new_label;

func _process_text(text: String) -> Array:
    var i: int = 0;
    var final_text: String = "";
    var detected_size: int = default_line_size;
    while (i < text.length()):
        var character: String = text[i];
        if (character == '['):
            if (i >= text.length() || text[i + 1] != "s"):
                final_text += text[i];
                i += 1;
                continue;
            i += 3; # should skip over [s=
            var size_text: String = "";
            while (text[i].is_valid_int()):
                size_text += text[i];
                i += 1;
            detected_size = int(size_text);
            i += 1; # skips over ]
            continue;
        
        final_text += text[i];
        i += 1;
    
    return [final_text, detected_size];

func _generate_tooltip_text() -> void:
    for child in text_container.get_children():
        child.queue_free();
    
    for line in text.split('\n'):
        var processed_text: Array = _process_text(line);
        var label: RichTextLabel = _create_text_label(processed_text[0], processed_text[1]);
        text_container.add_child(label);

func _regenerate_tooltip() -> void:
    _generate_tooltip_text();

func toggle(new_text: String):
    self.text = new_text;
    self.visible = true;

func _ready() -> void:
    self.z_index = 999;
    self.top_level = true;
    self.visible = false;

func _draw() -> void:
    self.size = Vector2(0, 0);
    _regenerate_tooltip();
    self.size = Vector2(max(max_size.x, self.text_container.size.x), min(max_size.y, self.text_container.size.y + default_line_size));
    
func _process(delta: float) -> void:
    queue_redraw();
    if (!self.visible): return;
    var position = get_viewport().get_mouse_position().min(get_viewport().get_visible_rect().size - self.size - self.padding);
    
    self.position = round(position + padding);
