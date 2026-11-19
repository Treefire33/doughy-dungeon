extends Node2D

# adds borders to the game screen and also properly scales it
@export var game_control: Control;
@export var game_viewport_container: SubViewportContainer;
@export var game_container: SubViewport;
@export var game_borders: Control;
var current_scene: Node = null;

func switch_scene(scene_path: Variant):
    if (is_instance_valid(self.current_scene)): self.current_scene.queue_free.call_deferred();
    var new_scene: Node;
    if (scene_path is String):
        new_scene = ResourceLoader.load(scene_path).instantiate();
    elif (scene_path is PackedScene):
        new_scene = scene_path.instantiate();
    elif (scene_path is Node):
        new_scene = scene_path;
    else: push_error("Invalid scene path for SuperLoader.");
    new_scene.process_mode = Node.PROCESS_MODE_PAUSABLE;
    self.game_container.add_child.call_deferred(new_scene);
    self.current_scene = new_scene;

func change_font(font_file: Font):
    game_control.theme.default_font = font_file;

func _bootstrap_loader():
    var current_scene = get_tree().current_scene;
    if (current_scene is RPGScene):
        RPGManager.move_rooms(current_scene.scene_id);
        current_scene.queue_free();
    elif (current_scene != self):
        await current_scene.get_parent().ready;
        current_scene.reparent(self.game_container);
        self.current_scene = current_scene;
    else: switch_scene("res://Scenes/title_screen.tscn");

func _enter_tree() -> void:
    RenderingServer.set_default_clear_color(Color.BLACK);

func _ready() -> void:
    change_font(Settings.font_dict[Settings.game_font]);
    _bootstrap_loader();

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
