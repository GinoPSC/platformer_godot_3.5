extends Area2D;
var FPS = Engine.get_iterations_per_second();

var direction = 1;
var IDJ = 0;
var speed_dir = Vector2(0,0);
var speed = 20;
var time = 13;

func _ready():
	if FPS == 60:
		speed /= 2;
		time *= 2;
	if direction == 2:
		self.rotation_degrees = 90;
	elif direction == 3:
		self.rotation_degrees = 90;

var delete_this = false;
var enemy_hit = false;
func _physics_process(_delta):
	for enemy in self.get_overlapping_bodies():
		if !delete_this:
			if "Main Block" in enemy.name:
				delete_this = true;
			elif "Enemy Type" in enemy.name:
				if !enemy.e_body.defeat:
					enemy.e_body.damage_type = 2;
					enemy.e_body.range_hit = true;
					enemy.e_body.damage += 4;
					enemy_hit = true;
					delete_this = true;
	
	if direction == 0:
		speed_dir.x = -speed;
	elif direction == 1:
		speed_dir.x = speed;
	elif direction == 2:
		self.rotation_degrees = 90;
		speed_dir.y = -speed;
	elif direction == 3:
		self.rotation_degrees = 90;
		speed_dir.y = speed;
	self.position += speed_dir;
	
	if time <= 0:
		delete_this = true;
		#print("Bullet deleted!");
	time -= 1;
	
	if delete_this:
		var personaje = self.get_tree().get_nodes_in_group("Character")[IDJ];
		if enemy_hit:
			personaje.score += 100;
		self.queue_free();


