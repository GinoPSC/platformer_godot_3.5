extends Area2D;

var direction = 1;
var IDJ = 0;
var time = 1;

func _ready():
	if direction == 0:
		self.scale.x = -1;
	elif direction == 1:
		self.scale.x = 1;

var delete_this = false;
var enemy_hit = false;
func _physics_process(_delta):
	for enemy in self.get_overlapping_bodies():
		if "Enemy Type" in enemy.name:
			if !enemy.e_body.defeat:
				enemy.e_body.damage_type = 1;
				enemy.e_body.melee_hit = true;
				enemy.e_body.damage += 20;
				delete_this = true;
				enemy_hit = true;
	
	if time <= 0:
		delete_this = true;
	time -= 1;
	
	if delete_this:
		var personaje = self.get_tree().get_nodes_in_group("Character")[IDJ];
		if enemy_hit:
			personaje.score += 500;
		self.queue_free();
