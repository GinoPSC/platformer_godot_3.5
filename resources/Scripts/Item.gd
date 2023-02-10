extends KinematicBody2D;

const UP = Vector2(0,-1);
const GRAVITY = 12;
const MAXFALLSPEED = 180;

var item = 0;
var x = 0;
func _ready():
	var y = 11+(sprite_config[item][2]*60);
	x = 11+(sprite_config[item][1]*60);
	
	if item == 17: $Sprite.position.y -= 5;
	$Sprite.region_rect.position = Vector2(x, y);
	$Sprite.region_rect.size = Vector2(48, 48);

var current_sprite = 0;
var current_time = 0;
var delete_this = false;
var onFloor = false;
var motion = Vector2(0,0);
func _physics_process(_delta):
	onFloor = self.is_on_floor();
	motion.y += GRAVITY;
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED;
	var snap = Vector2.DOWN * 2;
	motion = self.move_and_slide_with_snap(motion, snap, UP, true);
	
	for personaje in $HitBox.get_overlapping_bodies():
		if "Personaje" in personaje.name:
			if item == 0: personaje.weapon = 2;
			if item == 9: personaje.weapon = 1;
			if item == 17: personaje.bomb_ammo += 10;
			delete_this = true;
			break;
	
	if delete_this:
		var target = self.get_tree().get_nodes_in_group("Spawner")[4];
		if target: target.sfx_queue.append(
			[21, Vector2(self.position.x, self.position.y-10), true]
		);
		self.queue_free();

var sprite_config = [
	[0,0,0],	#0 heavy-machine-gun
	[0,1,0],	#1 rocket-launcher
	[0,2,0],	#2 shotgun
	[0,3,0],	#3 flame-shot
	[0,4,0],	#4 laser-gun
	[0,5,0],	#5 iron-lizard
	[0,6,0],	#6 drop-shot
	[0,7,0],	#7 super-grenade
	[0,8,0],	#8 enemy-chaser
	[0,9,0],	#9 two-machine-guns
	[0,10,0],	#10 zantetsu-sword
	[0,11,0],	#11 thunder-shot
	[1,0,1],	#12 super-h
	[1,0,2],	#13 super-r
	[1,0,3],	#14 super-s
	[1,0,4],	#15 super-f
	[1,0,5],	#16 super-l
	[2,0,6],	#17 bomb-crate
	[2,0,7],	#18 ammo-crate
	[2,0,8],	#19 normal-bomb
	[2,0,9],	#20 fire-bomb
	[2,0,10],	#21 gas-fuel
	[2,0,11],	#22 normal-cannon
	[2,0,12],	#23 armor-pierce
	[0,0,13],	#24 stones
	[3,0,14],	#24 crate
];
