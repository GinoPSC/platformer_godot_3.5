extends Node2D;
var target = null;
var players = [];



#0 Rebel-Soldier
#1 R-Shobu
#2 Girida-O
var rebel_army_rutes = [
	load("res://resources/Objects/Rebel_Soldier.tscn"),
	load("res://resources/Objects/R_Shobu.tscn"),
	load("res://resources/Objects/Girida_O.tscn")
];
func rebel_army_spawn(unit, dir, pos):
	var enemy = rebel_army_rutes[unit].instance();
	enemy.set_position(pos);
	enemy.direction = dir;
	self.add_child(enemy);
	enemy.add_to_group("Enemy");

func _ready():
	#rebel_soldier_spawn(0, Vector2(200, 0));
	pass;

func test_spawn():
	if self.get_child_count() == 0:
		var rng = RandomNumberGenerator.new();
		for x in 3:
			rng.randomize();
			var my_random_number = rng.randf_range(50, 250);
			rebel_army_spawn(0, 0, Vector2(my_random_number, 0));

var enemy_queue = [];
func _physics_process(_delta):
	target = self.get_tree().get_nodes_in_group("Camera")[0];
	if target:
		for request in enemy_queue:
			if request[3] && target.true_pos().x+350 >= request[2].x:
				request[3] = false;
				rebel_army_spawn(request[0], request[1], request[2]);
