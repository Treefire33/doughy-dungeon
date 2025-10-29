extends RPGInteractable
class_name RPGNPC

# Corresponds SceneID to Dialogue; 
@export var dialogue_dict: Dictionary[int, DialogueData] = {};

func get_dialogue(scene_id: int):
	if (dialogue_dict.get(scene_id) == null): return null;
	return dialogue_dict[scene_id];
