extends Abstract_Enemy;

const route_sprite = "res://resources/Sprites/Enemies/Girida_O/Body.png"
const route_config = "res://resources/Scripts/Enemies/Girida_O_Config.gd";
const sprite_sheet = preload(route_sprite);
const config_ = preload(route_config);
func _ready():
	init_body();
	set_texture(sprite_sheet, Rect2(11,11,108,48));
	set_config(config_, 1, Rect2(2,0,22,20), 200, false);
	add_child(e_body);
	add_child(e_texture);
	bounce = true;
	#self.move_child(e_body, 0);

var smooth_value = 0;
func smooth_track(value):
	if value > smooth_value:
		smooth_value += 1;
	elif smooth_value > value:
		smooth_value -= 1;
	return smooth_value;

func track_player(current_sprite):
	var sz = $Sprite.region_rect.size.x;
	$Sprite.region_rect.position.x = 11+((sz+12)*current_sprite);

var shoot_attack = 0;
var amount = 0;
var cooldown = 0;
func enemy_attack(dir, reset_shot=false):
	if reset_shot:
		shoot_attack = 0;
		amount = 0;
		cooldown = 0;
	elif shoot_attack > 60:
		if cooldown <= 0:
			if amount < 2:
				var attack = self.get_tree().get_nodes_in_group("Spawner")[1];
				var Vpos = Vector2(self.position.x+(5*dir), self.position.y-15);
				attack.enemy_attack_queue.append([1, target_player.IDJ, Vpos, true]);
				amount += 1;
				cooldown = 60;
			else:
				shoot_attack = 0;
				amount = 0;
		else: cooldown -= 1;
	else: shoot_attack += 1;

var girida_attack = false;
var move = false;
var stop = false;
var start = false;
var state = 0;
var shoot_girida = false;
var loop_time = 0;
var IA_PATTERN = 0;
var Comp_E = 0;
func _physics_process(_delta):
	call_physics_process();
	var cannon_pos = e_body.position;
	cannon_pos.y -= 23;
	cannon_pos.x += 2;
	$Sprite.position = cannon_pos;
	$Sprite.self_modulate = e_texture.get_modulate();
	
	shoot_girida = false;
	var dist = target_player_distance.x;
	var TD = target_player_dir;
	if (-20 < dist && dist < 20) || e_body.defeat:
		motion.x = 0;
		move = false;
		stop = true;
		start = false;
		shoot_girida = true;
		loop_time = 0;
		IA_PATTERN = 1;
	elif (direction == 0 && dist > 20) || (direction == 1 && -20 < dist):
		if start && state == 0: pass; else:
			if(
				(loop_time > 100 && IA_PATTERN == 0) ||
				(loop_time > 200 && IA_PATTERN == 1)
			):
				IA_PATTERN += 1;
				if IA_PATTERN > 1: IA_PATTERN = 0;
				loop_time = 0;
			else:
				loop_time += 1;
		
		if IA_PATTERN == 0:
			if start && state == 1:
				motion.x = 50*TD;
			move = true;
			stop = false;
			start = true;
		elif IA_PATTERN == 1:
			shoot_girida = true;
			motion.x = 0;
			move = false;
			stop = true;
			start = false;
	else:
		if start && state == 1:
			motion.x = 50*TD;
		move = true;
		stop = false;
		start = true;
		loop_time = 0;
		IA_PATTERN = 1;
	
	var lock_on = 4;
	if (
		(direction == 0 && TD == -1) ||
		(direction == 1 && TD == 1)
	):
		if -20 < dist && dist < 20: lock_on = 0;
		elif -50 < dist && dist < 50: lock_on = 1;
		elif -80 < dist && dist < 80: lock_on = 2;
		elif -110 < dist && dist < 110: lock_on = 3;
		else: lock_on = 4;
	else: lock_on = 0;
	track_player(smooth_track(lock_on));
	if !e_body.defeat:
		if shoot_girida: enemy_attack(TD);
		else: enemy_attack(TD,true);
	
	if An_E == 4: $Sprite.visible = false;
	if e_texture.SpriteEND:
		if An_E == 3:
			state = 0;
		if An_E == 2:
			state = 1;
	
	if !onFloor:
		if e_body.defeat:
			An_E = 4;
		else:
			An_E = 0;
	else:
		if e_body.defeat:
			An_E = 4;
		else:
			if start && state == 0:
				An_E = 2;
			elif move:
				An_E = 1;
				state = 1;
			elif stop && state == 1:
				An_E = 3;
			else:
				An_E = 0;
	e_texture.update_sprite(An_E);
	if An_E == 4 && Comp_E == 0:
		var target = self.get_tree().get_nodes_in_group("Spawner")[4];
		if target: target.sfx_queue.append(
			[2, Vector2(self.position.x+5, self.position.y-30), true]
		);
		Comp_E += 1;
	if e_texture.SpriteEND && An_E == 4:
		var target = self.get_tree().get_nodes_in_group("Spawner")[4];
		if target: target.sfx_queue.append(
			[1, Vector2(self.position.x+5, self.position.y-20), true]
		);
		e_body.delete = true;
