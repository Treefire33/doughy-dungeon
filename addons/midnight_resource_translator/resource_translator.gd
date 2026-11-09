@tool
extends EditorTranslationParserPlugin

func pack_string(string: String) -> PackedStringArray:
    return PackedStringArray([string]);

func _parse_file(path: String) -> Array[PackedStringArray]:
    var resource = ResourceLoader.load(path);
    var strings: Array[PackedStringArray] = [];

    if (resource is ItemData):
        strings.append(pack_string(resource.name));
        strings.append(pack_string(resource.flavour_text));
        strings.append(pack_string(resource.description));
    elif (resource is EnemyData):
        strings.append(pack_string(resource.name));
        strings.append(pack_string(resource.flavour_text));
    elif (resource is DungeonData):
        strings.append(pack_string(resource.name));
        strings.append(pack_string(resource.description));
    # elif (resource is DialogueData):
    #     for dialogue in resource.dialogue:
    #         strings.append(pack_string(dialogue.speech));

    return strings;

func _get_recognized_extensions() -> PackedStringArray:
    return ["tres"];
