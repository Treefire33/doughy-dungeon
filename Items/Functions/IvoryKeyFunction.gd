extends ItemFunction

var attack: int = 0;
var stamina: int = 0;
var defense: int = 0;

func purchased(args: ItemFunction.ItemFunctionArgs):
    if (!args.purchased): return;
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, attack, "ivoryAttack");
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, stamina, "ivoryStamina");
    args.user.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxDuration, defense, "ivoryDefense");

    ItemUtils.show_custom_toast("Do Re Mi Fa Sol La Ti Do!");

func decision(args: ItemFunction.ItemFunctionArgs):
    if (args.user is not Player): return;

    match (decision):
        Enum.Decision.Attack, Enum.Decision.AttackHeavy:
            attack += 1;
            args.user.update_stat_mod("ivoryAttack", attack);
            ItemUtils.show_custom_toast("The key ressonates at an A.");
        Enum.Decision.Spell:
            defense += 1;
            args.user.update_stat_mod("ivoryDefense", defense);
            ItemUtils.show_custom_toast("The key ressonates at a D.");
        Enum.Decision.Rest:
            stamina += 1;
            args.user.update_stat_mod("ivoryStamina", stamina);
            ItemUtils.show_custom_toast("The key ressonates at an E.");

func room_decision(args: ItemFunction.ItemFunctionArgs):
    ItemUtils.show_custom_toast("The key goes dead.");
    attack = 0; defense = 0; stamina = 0;
    args.room_manager.player.update_stat_mod("ivoryAttack", attack);
    args.room_manager.player.update_stat_mod("ivoryDefense", defense);
    args.room_manager.player.update_stat_mod("ivoryStamina", stamina);
