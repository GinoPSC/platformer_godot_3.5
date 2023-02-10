extends Node2D;
var rutas = [
	load("res://resources/Objects/Bullet.tscn"),
	load("res://resources/Objects/Knife Cut.tscn"),
	load("res://resources/Objects/Baton Smash.tscn"),
	load("res://resources/Objects/Bomb.tscn"),
	load("res://resources/Objects/HeavyBullet.tscn"),
	load("res://resources/Objects/HeavyBullet.tscn")
];

var attack_queue = [];
func _physics_process(_delta):
	for request in attack_queue:
		if request[3]:
			request[3] = false;
			var attack = rutas[request[0]].instance();
			attack.set_position(request[2]);
			attack.direction = request[1];
			attack.IDJ = request[4];
			if request[0] == 4: attack.dual = true;
			self.add_child(attack);
			attack.add_to_group("Attack");
