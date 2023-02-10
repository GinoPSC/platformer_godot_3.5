extends Abstract_Object;

var TD = 1;
var lock_on = 0;
var dist = 0;
var speed = 0;
func _ready():
	call_ready();
	target_player_pos(target);
	TD = target_player_dir;
	dist = target_player_distance.x;
	
	if -20 < dist && dist < 20:
		lock_on = 1;
	elif -50 < dist && dist < 50:
		lock_on = 2;
	elif -80 < dist && dist < 80:
		lock_on = 3;
	elif -110 < dist && dist < 110:
		lock_on = 4;
	else:
		lock_on = 5;
	motion.y = -300;
	
	speed = (dist*TD)+(lock_on*50)*TD;

var slow = false;
func _physics_process(_delta):
	self.call_physics_process();
	
	var current_dist = target_player_distance.x;
	if -30 < current_dist && current_dist < 30 && !slow:
		slow = true;
	if slow: speed /= 1.05;
	if FPS == 30: speed /= 1.020;
	
	if TD == -1:
		if speed < -120:
			speed = -120;
	else:
		if speed > 120:
			speed = 120;
	motion.x = speed;
	self.rotation_degrees += 25*TD;
	
	var chain = [
		[0,8],[1,0],[2,0],[3,0]
	];
	$Sprite.region_rect = animate_sprite(
		sprite_region.position,
		sprite_region.size,
		true,0,chain
	);
	
	var player_hit = self.detect_collision_with("Personaje");
	
	if onFloor || player_hit:
		delete_this = true;

