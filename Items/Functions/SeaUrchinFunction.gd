extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
    if (user is Player): return;
    if (target is not Player): return;
    target = target as Player;
    var sharp_count = target.items.get("SharpeningStone", 0);
    if (sharp_count > 0): 
        if (randi_range(0, 100) < sharp_count * 5):
            ItemUtils.show_activation_toast("Sea Urchin Spikes");
            user.health -= target.attack;
