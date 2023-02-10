extends Node2D;

var enemy_attacks_route = [
	load("res://resources/Objects/drop_bomb.tscn"),
	load("res://resources/Objects/Cannon.tscn"),
	load("res://resources/Objects/throw_bomb.tscn")
];
func _ready():
	pass;

func spawn_enemy_attack(attack, id_tg, pos):
	var object = enemy_attacks_route[attack].instance();
	object.position = pos;
	object.target = id_tg;
	self.add_child(object);

var target = null;
var enemy_attack_queue = [];
func _physics_process(_delta):
	target = self.get_tree().get_nodes_in_group("Camera")[0];
	if target:
		for request in enemy_attack_queue:
			if request[3] && target.true_pos().x+350 >= request[2].x:
				request[3] = false;
				spawn_enemy_attack(request[0], request[1], request[2]);
