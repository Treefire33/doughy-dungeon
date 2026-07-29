extends Node2D
class_name SuperLoader

# adds borders to the game screen and also properly scales it
@export var game_control: Control;
@export var game_viewport_container: SubViewportContainer;
@export var game_container: SubViewport;
@export var game_borders: Control;
var current_scene: Node = null;

static var super_loader: SuperLoader;

func switch_scene(scene_path: String):
    if (is_instance_valid(current_scene)): current_scene.queue_free.call_deferred();
    var new_scene = ResourceLoader.load(scene_path).instantiate();
    new_scene.process_mode = Node.PROCESS_MODE_PAUSABLE;
    game_container.add_child(new_scene);
    current_scene = new_scene;

func change_font(font_file: Font):
    game_control.theme.default_font = font_file;

func _enter_tree() -> void:
    if (!is_instance_valid(super_loader)):
        super_loader = self;
    
    RenderingServer.set_default_clear_color(Color.BLACK);

func _ready() -> void:
    change_font(Settings.font_dict[Settings.game_font]);
    switch_scene("res://Scenes/title_screen.tscn");

var default_game_size: Vector2 = Vector2(800, 450);
func _draw() -> void:
    var window_size = Vector2(get_window().size);
    game_control.size = window_size;

    var cont_width = default_game_size.x * window_size.y / default_game_size.y;
    var cont_height = window_size.y;

    if (cont_width > window_size.x):
        cont_width = window_size.x;
        cont_height = default_game_size.y * cont_width / default_game_size.x;

    game_viewport_container.size = Vector2(cont_width, cont_height);
    game_viewport_container.position = (window_size - game_viewport_container.size) / 2;

func _process(delta: float) -> void:
    game_borders.visible = Settings.game_borders;
