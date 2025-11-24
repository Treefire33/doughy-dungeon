extends RPGNPC
class_name NPCVendor

func _ready() -> void:
    if (!GlobalPlayer.met_vendor):
        self.visible = false;
        self.collider.process_mode = Node.PROCESS_MODE_DISABLED;
        return;

