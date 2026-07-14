import os

# quickly written script that converts a .tres ItemData file
# into a .gd ItemData file.
# used for translation
def generate_item_data_code(item_data: dict):
    function_prop = f'load(\"{item_data.get("function", None)}\")'
    if function_prop is None: function_prop = "null"

    return (
f"""extends ItemData

func _init() -> void:
    name = tr({item_data.get("name", "")});
    flavour_text = tr({item_data.get("flavour_text", "")});
    description = tr({item_data.get("description", "")});

    price = {int(item_data.get("price", "0"))};
    weight = {float(item_data.get("weight", "0.0"))};

    sprite = load("{item_data.get("sprite", "null")}");
    function = {function_prop};

    unique_stacking = {item_data.get("unique_stacking", "false")};
    painful = {item_data.get("painful", "false")};
""")

for file in os.listdir("."):
    if (".tres" not in file): continue

    item_data = {}
    ext_resources = {}
    with open(file, "+r") as item_file:
        for line in item_file.readlines():
            if line.strip() == "": continue
            if line.strip() == "[resource]": continue
            if "gd_resource" in line: continue
            split = line.split(' ')
            if "ext_resource" in line:
                resource_path = split[3][6:-1]
                resource_id = split[4][4:-3]
                ext_resources[resource_id] = resource_path
                continue

            key = split[0].strip()
            value = line.split('=')[1].strip()
            if "ExtResource" in value:
                value = ext_resources[value.removeprefix("ExtResource(\"")[:-2]]
            item_data[key] = value
    
    os.remove(file)

    with open(f"{file[:-4]}gd", "w+") as res_file:
        res_file.write(generate_item_data_code(item_data))
