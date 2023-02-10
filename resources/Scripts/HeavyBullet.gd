extends Area2D;
var FPS = Engine.get_iterations_per_second();

var direction = 1;
var IDJ = 0;
var speed_dir = Vector2(0,0);
var speed = 16;
var dualSpeed = 20;
var variantSpeed = 0.6;
var time = 18;
var dual = false;

func _ready():
	if FPS == 60:
		speed /= 2;
		time *= 2;
		dualSpeed /= 2;
		variantSpeed /= 2;
	personaje = self.get_tree().get_nodes_in_group("Character")[IDJ];
	
	if direction == 2:
		self.rotation_degrees = -90;
	elif direction == 3:
		self.rotation_degrees = 90;
	elif direction == 0:
		self.rotation_degrees = 180;
	elif direction == 10:
		self.rotation_degrees = -10;
	elif direction == 11:
		self.rotation_degrees = -35;
	elif direction == 12:
		self.rotation_degrees = -50;
	elif direction == 13:
		self.rotation_degrees = -80;
	elif direction == 14:
		self.rotation_degrees = -70;
	elif direction == 15:
		self.rotation_degrees = -45;
	elif direction == 16:
		self.rotation_degrees = -20;
	elif direction == -10:
		self.rotation_degrees = 10;
	elif direction == -11:
		self.rotation_degrees = 35;
	elif direction == -12:
		self.rotation_degrees = 50;
	elif direction == -13:
		self.rotation_degrees = 80;
	elif direction == -14:
		self.rotation_degrees = 70;
	elif direction == -15:
		self.rotation_degrees = 45;
	elif direction == -16:
		self.rotation_degrees = 20;
	elif direction == 20:
		self.rotation_degrees = 10;
	elif direction == 21:
		self.rotation_degrees = 35;
	elif direction == 22:
		self.rotation_degrees = 50;
	elif direction == 23:
		self.rotation_degrees = 80;
	elif direction == 24:
		self.rotation_degrees = 70;
	elif direction == 25:
		self.rotation_degrees = 45;
	elif direction == 26:
		self.rotation_degrees = 20;
	elif direction == -20:
		self.rotation_degrees = -10;
	elif direction == -21:
		self.rotation_degrees = -35;
	elif direction == -22:
		self.rotation_degrees = -50;
	elif direction == -23:
		self.rotation_degrees = -80;
	elif direction == -24:
		self.rotation_degrees = -70;
	elif direction == -25:
		self.rotation_degrees = -45;
	elif direction == -26:
		self.rotation_degrees = -20;
	
	if direction <= -10:
		$Sprite.rotation_degrees = 180;
	
	var variant = variantSpeed;
	if dual:
		variant = variantSpeed-0.2;
		speed = dualSpeed;
	
	if personaje.heavy_count < 1:
		if !dual: personaje.heavy_count += 0.5;
		personaje.heavy_count += 0.5;
		extra_dir = 0;
	elif personaje.heavy_count < 2:
		if !dual: personaje.heavy_count += 0.5;
		personaje.heavy_count += 0.5;
		extra_dir = variant;
	elif personaje.heavy_count < 3:
		if !dual: personaje.heavy_count += 0.5;
		personaje.heavy_count += 0.5;
		extra_dir = -variant;
	
	if personaje.heavy_count == 3:
		personaje.heavy_count = 0;
var delete_this = false;
var enemy_hit = false;
var personaje = null;
var extra_dir = 0;
func _physics_process(_delta):
	for enemy in self.get_overlapping_bodies():
		if !delete_this:
			if "Main Block" in enemy.name:
				delete_this = true;
			elif "Enemy Type" in enemy.name:
				if !enemy.e_body.defeat:
					enemy.e_body.damage_type = 4;
					enemy.e_body.range_hit = true;
					if dual: enemy.e_body.damage += 5;
					else: enemy.e_body.damage += 6;
					enemy_hit = true;
					delete_this = true;
	
	if direction == 0:
		speed_dir.x = -speed;
		self.rotation_degrees = 180;
	elif direction == 1:
		speed_dir.x = speed;
	elif direction == 2:
		self.rotation_degrees = -90;
		speed_dir.y = -speed;
	elif direction == 3:
		self.rotation_degrees = 90;
		speed_dir.y = speed;
	
	if direction == 0 || direction == 1:
		speed_dir.y = extra_dir;
	elif direction == 2 || direction == 3:
		speed_dir.x = extra_dir;
	
	if direction >= 20:
		speed_dir = Vector2(0,0);
		if direction == 20:
			self.rotation_degrees = 10;
		elif direction == 21:
			self.rotation_degrees = 35;
		elif direction == 22:
			self.rotation_degrees = 50;
		elif direction == 23:
			self.rotation_degrees = 80;
		elif direction == 24:
			self.rotation_degrees = 70;
		elif direction == 25:
			self.rotation_degrees = 45;
		elif direction == 26:
			self.rotation_degrees = 20;
		var radAngle = deg2rad(self.rotation_degrees);
		speed_dir.x = speed * cos(radAngle);
		speed_dir.y = speed * sin(radAngle);
	elif direction <= -20:
		speed_dir = Vector2(0,0);
		$Sprite.rotation_degrees = 180;
		if direction == -20:
			self.rotation_degrees = -10;
		elif direction == -21:
			self.rotation_degrees = -35;
		elif direction == -22:
			self.rotation_degrees = -50;
		elif direction == -23:
			self.rotation_degrees = -80;
		elif direction == -24:
			self.rotation_degrees = -70;
		elif direction == -25:
			self.rotation_degrees = -45;
		elif direction == -26:
			self.rotation_degrees = -20;
		var radAngle = deg2rad(self.rotation_degrees);
		speed_dir.x = -speed * cos(radAngle);
		speed_dir.y = -speed * sin(radAngle);
	elif direction >= 10:
		speed_dir = Vector2(0,0);
		if direction == 10:
			self.rotation_degrees = -10;
		elif direction == 11:
			self.rotation_degrees = -35;
		elif direction == 12:
			self.rotation_degrees = -50;
		elif direction == 13:
			self.rotation_degrees = -80;
		elif direction == 14:
			self.rotation_degrees = -70;
		elif direction == 15:
			self.rotation_degrees = -45;
		elif direction == 16:
			self.rotation_degrees = -20;
		var radAngle = deg2rad(self.rotation_degrees);
		speed_dir.x = speed * cos(radAngle);
		speed_dir.y = speed * sin(radAngle);
	elif direction <= -10:
		speed_dir = Vector2(0,0);
		$Sprite.rotation_degrees = 180;
		if direction == -10:
			self.rotation_degrees = 10;
		elif direction == -11:
			self.rotation_degrees = 35;
		elif direction == -12:
			self.rotation_degrees = 50;
		elif direction == -13:
			self.rotation_degrees = 80;
		elif direction == -14:
			self.rotation_degrees = 70;
		elif direction == -15:
			self.rotation_degrees = 45;
		elif direction == -16:
			self.rotation_degrees = 20;
		var radAngle = deg2rad(self.rotation_degrees);
		speed_dir.x = -speed * cos(radAngle);
		speed_dir.y = -speed * sin(radAngle);
	
	self.position += speed_dir;
	if time <= 0:
		delete_this = true;
		#print("Bullet deleted!");
	time -= 1;
	
	if delete_this:
		if enemy_hit:
			personaje.score += 100;
		self.queue_free();
