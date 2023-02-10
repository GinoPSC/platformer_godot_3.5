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
		motion.y = -350;
	elif -50 < dist && dist < 50:
		lock_on = 2;
		motion.y = -250;
	elif -80 < dist && dist < 80:
		lock_on = 3;
		motion.y = -150;
	elif -110 < dist && dist < 110:
		lock_on = 4;
		motion.y = -120;
	else:
		lock_on = 5;
		motion.y = -120;
	
	speed = (dist*TD)+(lock_on*50)*TD;

var slow = false;
func _physics_process(_delta):
	self.call_physics_process();
	
	var current_dist = target_player_distance.x;
	if -30 < current_dist && current_dist < 30 && !slow:
		slow = true;
	if slow:
		if lock_on >= 4:  speed /= 1.05;
		else: speed /= 1.1;
	if FPS == 30: speed /= 1.030;
	
	if TD == -1:
		if speed < -300:
			speed = -300;
	else:
		if speed > 300:
			speed = 300;
	motion.x = speed;
	
	var chain = [
		[0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],
		[10,0],[11,0],[12,0],[13,0],[14,0],[15,0],[16,0],[17,0],[18,0]
	];
	$Sprite.region_rect = animate_sprite(
		sprite_region.position,
		sprite_region.size,
		true,11,chain
	);
	
	var player_hit = self.detect_collision_with("Personaje");
	
	if onFloor || player_hit:
		delete_this = true;

