@tool
extends TextureRect
class_name AnimatedTextureRect

## A one-to-one port of the original source code for AnimatedSprite2D with
## the only change being that I made the frame texture draw to a TextureRect.

signal animation_finished();
signal animation_looped();
signal animation_changed();
signal frame_changed();
signal frames_changed();

var _frames: SpriteFrames;
@export var frames: SpriteFrames:
    get: return _frames;
    set(value):
        if (_frames == value): return;
        if (is_instance_valid(_frames)):
            _frames.disconnect(&"changed", _res_changed);
        _frames = value;
        if (is_instance_valid(_frames)):
            _frames.connect(&"changed", _res_changed);
            var animation_list: PackedStringArray = frames.get_animation_names();
            if (animation_list.is_empty()):
                _animation = StringName();
            else:
                if (!_frames.has_animation(_animation)):
                    _animation = animation_list[0];
        stop();

        notify_property_list_changed();
        queue_redraw();
        frames_changed.emit();

var _animation: StringName = &"default";
@export var animation: StringName:
    get: return _animation;
    set(value):
        if (_animation == value): return;

        _animation = value;

        animation_changed.emit();

        if (Engine.is_editor_hint()): return;

        if (is_instance_valid(_frames)):
            _animation = StringName();
            stop();
            return;
        
        if (_animation == StringName() || _frames.get_frame_count(_animation) == 0):
            stop();
            return;
        elif (!_frames.get_animation_names().has(_animation)):
            _animation = StringName();
            stop();
            return;
        
        if (signf(get_playing_speed()) < 0):
            set_frame_and_progress(_frames.get_frame_count(_animation) - 1, 1.0);
        else:
            set_frame_and_progress(0, 0.0);
        
        notify_property_list_changed();
        queue_redraw();

var _frame: int = 0;
@export var frame: int:
    get: return _frame;
    set(value):
        set_frame_and_progress(value, 1.0 if signf(get_playing_speed()) < 0 else 0.0);

var _speed_scale: float = 1.0;
@export var speed_scale: float:
    get: return _speed_scale;
    set(value): _speed_scale = speed_scale;

var _custom_speed_scale: float = 1.0;
var _frame_speed_scale: float = 1.0;
var _frame_progress: float = 0.0;
var _playing: bool = false;

func set_frame_and_progress(p_frame: int, p_progress: float):
    if (!is_instance_valid(frames)): return;

    var has_animation: bool = _frames.has_animation(animation);
    var end_frame: int = max(0, frames.get_frame_count(animation) - 1) if has_animation else 0;
    var is_changed: bool = _frame != p_frame;

    if (p_frame < 0):
        _frame = 0;
    elif (has_animation && p_frame > end_frame):
        _frame = end_frame;
    else:
        _frame = p_frame;
    
    _calc_frame_speed_scale();
    _frame_progress = p_progress;

    if (!is_changed): return;
    queue_redraw();
    frame_changed.emit();

func get_playing_speed() -> float:
    if (!_playing): return 0;

    return speed_scale * _custom_speed_scale;

func play(p_name: StringName = StringName(), p_custom_scale: float = 1.0, p_from_end = false):
    var name: StringName = p_name;

    if (name == StringName()): name = _animation;

    if (!is_instance_valid(frames) || !frames.has_animation(name)): return;

    if (frames.get_frame_count(name) == 0): return;

    _playing = true;
    _custom_speed_scale = p_custom_scale;

    if (name != _animation):
        _animation = name;
        var end_frame: int = max(0, frames.get_frame_count(_animation) - 1);

        if (p_from_end):
            set_frame_and_progress(end_frame, 1.0);
        else:
            set_frame_and_progress(0, 0.0);
        animation_changed.emit();
    else:
        var end_frame: int = max(0, frames.get_frame_count(_animation) - 1);
        var is_backward: bool = signf(speed_scale * _custom_speed_scale) < 0;

        if (p_from_end && is_backward && frame == 0 && _frame_progress <= 0.0):
            set_frame_and_progress(end_frame, 1.0);
        elif (p_from_end && !is_backward && frame == end_frame && _frame_progress >= 1.0):
            set_frame_and_progress(0, 0.0);
    
    set_process_internal(true);
    notify_property_list_changed();
    queue_redraw();

func _stop_interal(p_reset: bool):
    _playing = false;
    if (p_reset):
        _custom_speed_scale = 1.0;
        set_frame_and_progress(0, 0.0);
    notify_property_list_changed();
    set_process_internal(false);

func pause():
    _stop_interal(false);

func stop():
    _stop_interal(true);

func _get_frame_duration():
    if (is_instance_valid(frames) && frames.has_animation(animation)):
        return frames.get_frame_duration(animation, frame);
    return 1.0;

func _calc_frame_speed_scale():
    _frame_speed_scale = 1.0 / _get_frame_duration();

func _res_changed():
    set_frame_and_progress(_frame, _frame_progress);
    queue_redraw();
    notify_property_list_changed();

func _notification(what: int) -> void:
    match (what):
        NOTIFICATION_INTERNAL_PROCESS:
            if (!is_instance_valid(_frames) || !_frames.has_animation(_animation)): return;

            var remaining: float = get_process_delta_time();
            var i: int = 0;
            while (remaining > 0):
                var speed: float = _frames.get_animation_speed(animation) * speed_scale * _custom_speed_scale * _frame_speed_scale;
                var abs_speed: float = abs(speed);

                if (speed == 0): return;

                var frame_count: int = _frames.get_frame_count(animation);
                var last_frame: int = frame_count - 1;
                if (signf(speed) > 0):
                    if (_frame_progress >= 1.0):
                        if (_frame >= last_frame):
                            var loop: int = _frames.get_animation_loop_mode(animation);
                            if (loop == SpriteFrames.LOOP_NONE):
                                _frame = last_frame;
                                pause();
                                animation_finished.emit();
                                return;
                            if (loop == SpriteFrames.LOOP_PINGPONG):
                                _frame = last_frame;
                                _custom_speed_scale *= -1;
                            else:
                                frame = 0;
                                animation_looped.emit();
                        else:
                            _frame += 1;
                        _calc_frame_speed_scale();
                        _frame_progress = 0.0;
                        queue_redraw();
                        frame_changed.emit();
                    var to_process: float = min((1.0 - _frame_progress) / abs_speed, remaining);
                    _frame_progress += to_process * abs_speed;
                    remaining -= to_process;
                else:
                    if (_frame_progress <= 0.0):
                        if (_frame >= last_frame):
                            var loop: int = _frames.get_animation_loop_mode(animation);
                            if (loop == SpriteFrames.LOOP_NONE):
                                _frame = 0;
                                pause();
                                animation_finished.emit();
                                return;
                            if (loop == SpriteFrames.LOOP_PINGPONG):
                                _frame = 0;
                                _custom_speed_scale *= -1;
                            else:
                                frame = last_frame;
                                animation_looped.emit();
                        else:
                            _frame += 1;
                        _calc_frame_speed_scale();
                        _frame_progress = 0.0;
                        queue_redraw();
                        frame_changed.emit();
                    var to_process: float = min(_frame_progress / abs_speed, remaining);
                    _frame_progress -= to_process * abs_speed;
                    remaining -= to_process;
                
                    i += 1;
                    if (i > frame_count): return;
        NOTIFICATION_DRAW:
            if (!is_instance_valid(frames) || !frames.has_animation(animation)): return;
            
            var texture: Texture2D = frames.get_frame_texture(animation, frame);
            if (!is_instance_valid(texture)): return;

            self.texture = texture;
