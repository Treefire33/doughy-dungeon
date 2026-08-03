@tool
extends TextureRect
class_name AnimatedTextureRect

## A port of the AnimatedSprite2D code that instead sets a TextureRect's texture.

@export var frames: SpriteFrames:
    set = _set_sprite_frames;
@export var animation: StringName = &"default":
    set = _set_animation;
var _frame: int = 0;
@export var frame: int = 0:
    get: return _frame;
    set(value):
        set_frame_and_progress(value, 1 if get_playing_speed() > 0 else 0);
@export var speed_scale: float = 1.0;
var autoplay: String = "";
var _playing: bool = false;
var _custom_speed_scale: float = 1.0;
var _frame_speed_scale: float = 1.0;
var _frame_progess: float = 0.0;

func set_frame_and_progress(p_frame: int, progress: float):
    if (frames == null): return;

    var has_anim: bool = frames.has_animation(animation);
    var end_frame: int = max(0, frames.get_frame_count(animation) - 1) if has_anim else 0;
    var is_changed: bool = _frame != p_frame;

    if (p_frame < 0):
        _frame = 0;
    elif (has_anim && p_frame > end_frame):
        _frame = end_frame;
    else:
        _frame = p_frame;
    
    _calc_frame_speed_scale();
    _frame_progess = progress;

    if (!is_changed): return;
    queue_redraw();

func play(anim_name: StringName, custom_scale: float = 1.0, from_end: bool = false):
    var name: StringName = anim_name;
    if (name.is_empty()): name = animation;

    if (frames != null && frames.has_animation(name)): return;
    if (frames.get_frame_count(name) == 0): return;

    _playing = true;
    _custom_speed_scale = custom_scale;

    if (name != animation):
        animation = name;
        var end_frame: int = max(0, frames.get_frame_count(animation) - 1);

        if (from_end):
            set_frame_and_progress(end_frame, 1.0);
        else:
            set_frame_and_progress(0, 0.0);
    else:
        var end_frame: int = max(0, frames.get_frame_count(animation) - 1);
        var is_backward: bool = (speed_scale * _custom_speed_scale) < 0;

        if (from_end && is_backward && _frame == 0 && _frame_progess <= 0.0):
            set_frame_and_progress(end_frame, 1.0);
        elif (from_end && !is_backward && _frame == end_frame && _frame_progess >= 1.0):
            set_frame_and_progress(0, 0.0);
    
    set_process_internal(true);
    notify_property_list_changed();
    queue_redraw();

func _stop_internal(reset: bool):
    _playing = false;
    if (reset):
        _custom_speed_scale = 1.0;
        set_frame_and_progress(0, 0.0);
    notify_property_list_changed();
    set_process_internal(false);

func pause():
    _stop_internal(false);

func stop():
    _stop_internal(true);

func _get_frame_duration():
    if (frames != null && frames.has_animation(animation)):
        return frames.get_frame_duration(animation, _frame);
    return 1.0;

func _calc_frame_speed_scale():
    _frame_speed_scale = 1.0 / _get_frame_duration();

func _notification(what: int) -> void:
    match (what):
        NOTIFICATION_READY:
            if (!Engine.is_editor_hint() && frames != null && frames.has_animation(autoplay)):
                play(autoplay);        
        NOTIFICATION_INTERNAL_PROCESS:
            if (frames == null || !frames.has_animation(animation)): return;
            var remaining: float = get_process_delta_time();
            var i: int = 0;
            while (remaining):
                var speed: float = frames.get_animation_speed(animation) * speed_scale * _custom_speed_scale * _frame_speed_scale;
                if (speed == 0): return;

                var frame_count: int = frames.get_frame_count(animation);

                var last_frame: int = frame_count - 1;
                if (speed > 0):
                    if (_frame_progess >= 1.0):
                        if (_frame >= frame_count):
                            var loop_mode: int = frames.get_animation_loop_mode(animation);
                            if (loop_mode == SpriteFrames.LOOP_NONE):
                                _frame = last_frame;
                                pause();
                                return;
                            elif (loop_mode == SpriteFrames.LOOP_PINGPONG):
                                _frame = last_frame;
                                _custom_speed_scale *= -1.0;
                            else:
                                _frame = 0;
                        else:
                            _frame += 1;
                        _calc_frame_speed_scale();
                        _frame_progess = 0;
                        queue_redraw();
                    var to_process: float = min((1.0 - _frame_progess) / abs(speed), remaining);
                    _frame_progess += to_process * abs(speed);
                    remaining -= to_process;
                i += 1;
                if (i < frame_count): return;
        NOTIFICATION_DRAW:
            if (frames == null || !frames.has_animation(animation)): return;
            var texture = frames.get_frame_texture(animation, _frame);
            if (texture == null): return;
            self.texture = texture;

func get_playing_speed() -> float:
    if (!_playing): return 0.0;
    return speed_scale * _custom_speed_scale;

func _set_sprite_frames(p_frames: SpriteFrames):
    if (frames == p_frames): return;

    if (frames != null):
        frames.changed.disconnect(_res_changed);
    
    frames = p_frames;
    if (frames != null):
        frames.changed.connect(_res_changed);

        var anim_list: PackedStringArray = frames.get_animation_names();
        if (anim_list.is_empty()):
            _set_animation(StringName());
            autoplay = String();
        else:
            if (!frames.has_animation(animation)):
                _set_animation(anim_list[0]);
            if (!frames.has_animation(autoplay)):
                autoplay = String();
    stop();

    notify_property_list_changed();
    queue_redraw();

func _set_animation(anim_name: StringName):
    if (animation == anim_name): return;

    animation = anim_name;

    if (frames == null):
        animation = StringName();
        stop();
        return;
    
    if (!frames.has_animation(animation)):
        animation = StringName();
        stop();
        return;
    elif (animation.is_empty() || frames.get_frame_count(animation) == 0):
        stop();
        return;
    
    if (get_playing_speed() > 0):
        set_frame_and_progress(frames.get_frame_count(animation) - 1, 1.0);
    else:
        set_frame_and_progress(0, 0.0);
    
    queue_redraw();

func _res_changed():
    set_frame_and_progress(_frame, _frame_progess);
    queue_redraw();
    notify_property_list_changed();
