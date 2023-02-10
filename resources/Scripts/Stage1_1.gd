extends Node2D;


var LeftLimit = 0;
var RightLimit = 4152-300;
var TopLimit = -16;
var BottomLimit = 0;
var target = null;
var enemies = null;
var items = null;
func _ready():
	target = self.get_tree().get_nodes_in_group("Camera")[0];
	Limit_Update();

var Native_Resolution = Vector2(300,224);
func Limit_Update():
	target.limit_left = LeftLimit;
	target.limit_right = RightLimit+Native_Resolution.x;
	target.limit_top = TopLimit;
	target.limit_bottom = BottomLimit+Native_Resolution.y;

var spawn_active = false;
var animationsF;
func _physics_process(_delta):
	#print(target.true_pos().x);
	
	if 3000 < target.true_pos().x:
		TopLimit = -128;
	if 1565 <= target.true_pos().x:
		LeftLimit = 1565;
	elif target.true_pos().y == 0:
		TopLimit = 0;
	
	for animation in $Front.get_children():
		for x in 6:
			if animation.name == "back_river_"+str(x+1):
				if 2500 < target.true_pos().x:
					animation.speed_scale = 3;
				else: animation.speed_scale = 1;
	
	for animationF in animationsF:
		for x in 3:
			if animationF.name == "front_river_"+str(x+1):
				if 2500 < target.true_pos().x:
					animationF.speed_scale = 3;
				else: animationF.speed_scale = 1;
	
	Limit_Update();
	
	enemies = self.get_tree().get_nodes_in_group("Spawner")[2];
	items = self.get_tree().get_nodes_in_group("Spawner")[3];
	if enemies && items && !spawn_active:
		spawn_active = true;
		#[ 0:enemy, 1:direction, 2:position, 3:spawn ]
		for x in 18:
			enemies.enemy_queue.append([0, 0, Vector2(500+(200*x), 150), true]);
		for x in 18:
			enemies.enemy_queue.append([0, 0, Vector2(400+(200*x), 50), true]);
		enemies.enemy_queue.append([1, 0, Vector2(800, 50), true]);
		enemies.enemy_queue.append([1, 0, Vector2(1915, 50), true]);
		enemies.enemy_queue.append([1, 0, Vector2(2500, 10), true]);
		enemies.enemy_queue.append([1, 0, Vector2(3000, 50), true]);
		enemies.enemy_queue.append([1, 0, Vector2(3500, 50), true]);
		
		enemies.enemy_queue.append([2, 0, Vector2(900, 150), true]);
		enemies.enemy_queue.append([2, 0, Vector2(1700, 150), true]);
		enemies.enemy_queue.append([2, 0, Vector2(2400, 150), true]);
		enemies.enemy_queue.append([2, 0, Vector2(3000, 150), true]);
		enemies.enemy_queue.append([2, 0, Vector2(3600, 0), true]);
		enemies.enemy_queue.append([2, 0, Vector2(3700, 0), true]);
		
		#ITEMS
		items.item_queue.append([9, Vector2(150, 50), true]);
		items.item_queue.append([0, Vector2(175, 50), true]);
		items.item_queue.append([17, Vector2(125, 50), true]);

#func _physics_process(_delta):
#	for body in $Events.get_overlapping_bodies():
#		if body.name == "Personaje":
#			print(0);
