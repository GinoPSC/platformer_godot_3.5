extends KinematicBody2D;

#Init Data
var FPS = Engine.get_iterations_per_second();
var IDJ = 0;
var controles = [];
var projectiles = null;
var network_jump = false;

#CONSTs
const UP = Vector2(0,-1);
const MAXFALLSPEED = 180;
const MAXSPEED = 80;
const CRAWLSPEED = 30;
const JUMPMAXSPEED = 120;
const JUMPFORCE = 275;
const SMALLJUMPFORCE = 200;

#Personaje
var disabled = true;
var invincible = false;
var onFloor = false;
var motion = Vector2();
var dir = 1;
var Comp_D = 1;
var IJD = 0;
var IDM = 0;
var score = 0;
var weapon = 0;
var ammo = 0;
var HP = 1;
var disable_controls = false;
var defeat = false;
var air_defeat = false;

var GRAVITY = 24;
var JUMPACCEL = 12;
var ACCEL = 40;
func _ready():
	if FPS == 60:
		GRAVITY /= 2;
		JUMPACCEL /= 2;
		ACCEL /= 2;
	
	var shp = RectangleShape2D.new();
	shp.set_extents($HurtBox.shape.extents);
	$HurtBox.set_shape(shp);
	$HurtBox.position.y = 4;
	self.name = "Personaje_"+str(IDJ);
##NETWORK

func get_character_state():
	return [self.position, motion];

func _save_state() ->Dictionary:
	return {
		position_x = self.position.x,
		position_y = self.position.y,
		motion_x = motion.x,
		motion_y = motion.y
	}

func _load_state(state: Dictionary):
	self.position.x = state['position_x'];
	self.position.y = state['position_y'];
	motion.x = state['motion_x'];
	motion.y = state['motion_y'];

func Crouch_HurtBox(idx):
	var crouch_hurt_box = idx;
	if crouch_hurt_box:
		$HurtBox.position.y = 12;
		$HurtBox.shape.extents.y = 7;
	else:
		$HurtBox.position.y = 4;
		$HurtBox.shape.extents.y = 15;

var change_comp = 1;
var dir_change = false;
var dir_change_start = false;
var dir_change_end = false;
func turning(direction, force = false):
	if !onFloor || force:
		dir = direction;
		change_comp = dir;
		dir_change = false;
		dir_change_start = false;
		dir_change_end = false;
	elif onFloor && change_comp != direction && !dir_change:
		change_comp = direction;
		dir_change = true;

var CompB = 0;
var start_throw = false;
var sit_throw = false;
var run_throw = false;
var bomb_ammo = 10;
var bomb_onScreen = 0;
func Throwing():
	if controles[4] && CompB == 0 && !start_knife && bomb_onScreen < 2 && !disable_controls:
		CompB += 1;
		start_throw = true;
		start_shoot = false;
		buffer_shoot = false;
		re_shoot = true;
		sit_throw = false;
		run_throw = false;
		if controles[0]:
			turning(0);
			run_throw = true;
		elif controles[1]:
			turning(1);
			run_throw = true;
		if controles[2] && onFloor:
			sit_throw = true;
	elif !controles[4]:
		CompB = 0;

var CompJ = 0;
var RunJump = false;
var jump_frame_window = 3;
var jump_frame = jump_frame_window;
var jump_start = false;
var jump_end = false;
var jump = false;
var jump_force = false;
func Jumping():
	if FPS == 60: jump_frame_window = 3;
	elif FPS == 30: jump_frame_window = 2;
	
	if onFloor:
		RunJump = false;
	else:
		if RunJump:
			IJD = 0;
		else:
			IJD = 2;
	
	if jump_force:
		motion.y = -SMALLJUMPFORCE;
		if defeat: motion.y = -JUMPFORCE;
		RunJump = true;
		jump_force = false;
	elif !jump_end && onFloor:
		if controles[5] && !disable_controls:
			jump_start = true;
			
		if jump_start && controles[5]:
			jump_frame -= 1;
		
		if jump_start && !controles[5]:
			jump = true;
		elif jump_start && jump_frame <= 0:
			jump = true;
	elif !onFloor:
		jump_end = true;
	
	if jump_end && onFloor:
		jump_frame = jump_frame_window;
		jump_start = false;
		jump = false;
		if !controles[5]:
			jump_end = false;
			CompJ = 0;
	
	if jump && !jump_force:
		if CompJ == 0:
			CompJ = 1;
			if onFloor:
				if jump_frame == 0 || network_jump: motion.y = -JUMPFORCE;
				else: motion.y = -SMALLJUMPFORCE;
				if controles[0] || controles[1]:
					RunJump = true;

var start_shoot = false;
var cqc_rage = false;
var cqc_an = 1;
var start_knife = false;
var sit_knife = false;
var dir_shoot = -1;
var re_shoot = false;
var Comp_S = 0;
var Comp_K = 0;
var buffer_shoot = false;
var start_buffer_shoot = false;
var quick_shoot = false;
func Attacking():
	cqc_rage = false;
	for enemy in $CloseCombat.get_overlapping_bodies():
		if (
			"Enemy Type" in enemy.name &&
			!enemy.e_body.defeat &&
			enemy.e_body.type != 1
		):
			cqc_rage = true;
	
	if controles[6] && Comp_S == 0 && !disable_controls:
		Comp_S = 1;
		if cqc_rage:
			start_knife = true;
			start_shoot = false;
			sit_knife = false;
			if controles[2] && onFloor:
				sit_knife = true;
			cqc_an += 1;
			if cqc_an > 1:
				cqc_an = 0;
		elif !start_knife:
			if start_shoot && !buffer_shoot: buffer_shoot = true;
			elif !start_shoot: quick_shoot = true;
			if quick_shoot:
				diagonal_start = false;
			
			start_shoot = true;
			start_throw = false;
			if !diagonal_start:
				re_shoot = true;
				if controles[0]: turning(0,quick_shoot);
				elif controles[1]: turning(1,quick_shoot);
			if controles[2] && onFloor:
				dir_shoot = 3;
			elif controles[2] && !onFloor:
				dir_shoot = 2;
			elif controles[3]:
				dir_shoot = 1;
			else:
				dir_shoot = 0;
	if !controles[6]:
		Comp_S = 0;

var State_UP = 0;
var State_DW = 0;
func special_state(index):
	match index:
		0:
			if controles[0] || controles[1]:
				if Current_DW < 3 || landing == 2:
					State_UP = 5;
				else:
					State_UP = 6;
		1:
			if RunJump:
				State_UP = 2;
			else:
				State_UP = 1;
		2:
			if RunJump:
				State_UP = 3;
			else:
				State_UP = 4;

var before_up = 0;
var before_dw = 0;
var diagonal_shoot_up = 1;
var diagonal_shoot_down = 1;
func detect_diagonal_dir():
	before_up = diagonal_shoot_up;
	before_dw = diagonal_shoot_down;
	
	if weapon != 2:
		if (controles[2] || dir_shoot == 2) && !onFloor:
			diagonal_shoot_up = 0;
			diagonal_shoot_down = 2;
		elif (controles[3] || dir_shoot == 1) && !controles[2]:
			diagonal_shoot_up = 2;
			diagonal_shoot_down = 0;
		elif (!controles[3] && !controles[2]) || dir_shoot <= 0:
			diagonal_shoot_up = 1;
			diagonal_shoot_down = 1;
	else:
		if controles[2] && !onFloor:
			diagonal_shoot_up = 0;
			diagonal_shoot_down = 2;
		elif controles[3] && !controles[2]:
			diagonal_shoot_up = 2;
			diagonal_shoot_down = 0;
		elif !controles[3] && !controles[2]:
			diagonal_shoot_up = 1;
			diagonal_shoot_down = 1;

var diagonal_buffer = [];
var diagonal_start = false;
func diagonal_sprites(An_, SpriteEND):
	detect_diagonal_dir();
	
	if(
		start_throw || start_knife ||
		dir_change_start || sit_state ||
		quick_shoot || disable_controls
	):
		diagonal_start = false;
		diagonal_buffer = [];
	else:
		if before_up != diagonal_shoot_up:
			var Ex = 0;
			if weapon == 2: Ex = 11;
			elif weapon == 1: Ex = 22;
			
			if(
				before_up == 1 && diagonal_shoot_up == 0 &&
				before_dw == 1 && diagonal_shoot_down == 2
			):
				if start_shoot && weapon == 2:
					diagonal_buffer.append([56,2,0,true]);
					dir_shoot = 2;
				else:
					diagonal_buffer.append([71+Ex,2,0,false]);
					walk_sync = false;
			elif(
				before_up == 0 && diagonal_shoot_up == 1 &&
				before_dw == 2 && diagonal_shoot_down == 1
			):
				if start_shoot && weapon == 2:
					diagonal_buffer.append([57,2,1,true]);
					dir_shoot = 0;
				else:
					diagonal_buffer.append([72+Ex,2,1,false]);
					walk_sync = false;
			elif(
				before_up == 1 && diagonal_shoot_up == 2 &&
				before_dw == 1 && diagonal_shoot_down == 0
			):
				if start_shoot && weapon == 2:
					diagonal_buffer.append([54,3,2,true]);
					dir_shoot = 3;
				else:
					diagonal_buffer.append([73+Ex,3,2,false]);
					walk_sync = false;
			elif(
				before_up == 2 && diagonal_shoot_up == 1 &&
				before_dw == 0 && diagonal_shoot_down == 1
			):
				if start_shoot && weapon == 2:
					diagonal_buffer.append([55,3,3,true]);
					dir_shoot = 0;
				else:
					diagonal_buffer.append([74+Ex,3,3,false]);
					walk_sync = false;
		
		if diagonal_buffer:
			if diagonal_buffer.size() > 2:
				diagonal_buffer.pop_back();
			if diagonal_buffer.size() > 1:
				var st = diagonal_buffer[0];
				var nd = diagonal_buffer[1];
				if(
					st[0] == nd[0] ||
					((st[2] == 3 || nd[2] == 3) && (st[2] == 1 || nd[2] == 1)) ||
					((st[2] == 2 || nd[2] == 2) && (st[2] == 0 || nd[2] == 0))
				):
					diagonal_buffer.pop_back();
			
			if SpriteEND && diagonal_buffer.size() > 1:
				diagonal_buffer.pop_front();
				if controles[0]: turning(0,true);
				elif controles[1]: turning(1,true);
			An_ = diagonal_buffer[0][0];
			if onFloor:
				if 3 == diagonal_buffer[0][1]:
					special_state(0);
			else:
				if 3 == diagonal_buffer[0][1]:
					special_state(1);
				else:
					special_state(2);
			if diagonal_buffer[0][3]:
				shoot_comp = An_;
			diag_comp = An_;
			diagonal_start = true;
			stop_aim = true;
			stoping = false;
	return An_;

func transition_sprites(An_, SpriteEND):
	if dir_change && !onFloor:
		dir = change_comp;
		dir_change = false;
		dir_change_end = false;
		dir_change_start = false;
	elif dir_change && !diagonal_start:
		if dir_change_start:
			if !dir_change_end:
				dir = change_comp;
				dir_change_end = true;
			else:
				if SpriteEND:
					dir_change_start = false;
					dir_change_end = false;
					dir_change = false;
		else: dir_change_start = true;
		
		var Ex = 0;
		if weapon == 2: Ex = 11;
		elif weapon == 1: Ex = 22;
		
		if controles[2]:
			An_ = 77+Ex;
		elif controles[3]:
			An_ = 75+Ex;
		else:
			An_ = 76+Ex;
		
		State_UP = 0;
		walk_sync = false;
		View_DW = false;
		
	return An_;

func stop_animations_up(An_, SpriteEND):
	if SpriteEND:
		if An_ == throw_comp:
			start_throw = false;
		if An_ == shoot_comp:
			if buffer_shoot: buffer_shoot = false;
			else: start_shoot = false;
		if An_ == diag_comp && diagonal_buffer.size() == 1:
			diagonal_start = false;
			diagonal_buffer = [];
		if An_ == melee_comp:
			start_knife = false;
		if stoping_start:
			stoping = false;
			stoping_start = false;
		if crouch_start:
			crouch_start = false;
		if crouch_end:
			crouch_end = false;

var An_UP = 0;
var An_DW = 0;
var View_UP = true;
var View_DW = true;
var Mercenario = null;
var Current_UP = 0;
var Current_DW = 0;
var stop_aim = false;
var walk_sync = false;
var stoping = false;
var stoping_start = false;
var sit_shoot_idle = false;
var sit_shoot_idle_start = false;
var diag_comp = 0;
var shoot_comp = 0;
var melee_comp = 0;
var throw_comp = 0;
var extra_comp = 0;
var landing = 0;
var sit_state = false;
var crouch_start = false;
var crouch_end = false;
func sprite_animation_up(An_, SpriteEND):
	View_DW = true;
	State_UP = 0;
	
	if !start_shoot:
		dir_shoot = -1;
	
	if controles[2] && onFloor && !disable_controls:
		if !crouch_start && !sit_state:
			crouch_start = true;
		sit_state = true;
	else:
		if !crouch_end && sit_state:
			crouch_end = true;
		sit_state = false;
	
	if(
		((diagonal_start || dir_change_start) &&
		!start_knife && !start_throw) || defeat
	): pass; else:
		if onFloor:
			if landing == 1:
				landing = 2;
			else: landing = 0;
			stop_aim = false;
			
			#Sit Animations
			if controles[2]:
				View_DW = false;
				if start_knife && sit_knife && cqc_an == 0:
					An_ = 15;
					melee_comp = An_;
					sit_shoot_idle = true;
				elif start_knife && sit_knife && cqc_an == 1:
					An_ = 16;
					melee_comp = An_;
					sit_shoot_idle = true;
				elif start_throw && sit_throw:
					An_ = 17;
					throw_comp = An_;
					sit_shoot_idle = true;
				elif start_shoot && dir_shoot == 3:
					An_ = 14;
					shoot_comp = An_;
					sit_shoot_idle = true;
				elif crouch_start:
					An_ = 79;
					extra_comp = An_;
				elif controles[0] || controles[1]:
					An_ = 13;
				elif sit_shoot_idle:
					An_ = 81;
					extra_comp = An_;
					sit_shoot_idle_start = true;
				else:
					An_ = 12;
			else:
				sit_shoot_idle = false;
				if start_knife && !sit_knife && cqc_an == 0:
					An_ = 6;
					melee_comp = An_;
					special_state(0);
					stoping = false;
				elif start_knife && !sit_knife && cqc_an == 1:
					An_ = 7;
					melee_comp = An_;
					special_state(0);
					stoping = false;
				elif start_throw && !sit_throw:
					An_ = 8;
					throw_comp = An_;
					special_state(0);
					stoping = false;
				elif dir_shoot == 2:
					An_ = 11;
					shoot_comp = An_;
					stoping = false;
				elif dir_shoot == 1:
					An_ = 9;
					shoot_comp = An_;
					special_state(0);
					stoping = false;
				elif controles[3]:
					An_ = 4;
					special_state(0);
					stoping = false;
				elif start_shoot && dir_shoot == 0:
					An_ = 5;
					shoot_comp = An_;
					special_state(0);
					stoping = false;
				elif crouch_end:
					An_ = 80;
					extra_comp = An_;
					View_DW = false;
				elif controles[0] || controles[1]:
					An_ = 1;
					if Current_UP != Current_DW:
						walk_sync = true;
					if Current_UP > 3:
						stoping = true;
				elif stoping || stoping_start:
					An_ = 78;
					extra_comp = An_;
					View_DW = false;
					stoping_start = true;
				else:
					An_ = 0;
		else: #onAir
			landing = 1;
			if start_knife && !sit_knife && cqc_an == 0:
				An_ = 6;
				special_state(1);
				stop_aim = true;
				melee_comp = An_;
			elif start_knife && !sit_knife && cqc_an == 1:
				An_ = 7;
				special_state(1);
				stop_aim = true;
				melee_comp = An_;
			elif start_throw && !sit_throw:
				An_ = 8;
				special_state(1);
				stop_aim = true;
				throw_comp = An_;
			elif dir_shoot == 2:
				An_ = 11;
				special_state(2);
				stop_aim = true;
				shoot_comp = An_;
			elif dir_shoot == 1:
				An_ = 9;
				special_state(1);
				stop_aim = true;
				shoot_comp = An_;
			elif controles[2]:
				An_ = 10;
				special_state(2);
				stop_aim = true;
			elif controles[3]:
				An_ = 4;
				stop_aim = true;
				special_state(1);
			elif start_shoot && dir_shoot == 0:
				An_ = 5;
				special_state(1);
				stop_aim = true;
				shoot_comp = An_;
			elif stop_aim:
				An_ = 0;
				special_state(1);
				stoping = true;
			elif RunJump:
				An_ = 3;
				stoping = true;
			else:
				An_ = 2;
				stoping = true;
		
		var AD = 18;
		if An_ == extra_comp: AD = 11;
		if weapon == 1 && !diagonal_start:
			An_ += AD*2;
			throw_comp += AD*2;
			shoot_comp += AD*2;
			melee_comp += AD*2;
			extra_comp += AD*2;
		elif weapon == 2 && !diagonal_start:
			An_ += AD*1;
			throw_comp += AD*1;
			shoot_comp += AD*1;
			melee_comp += AD*1;
			extra_comp += AD*1;
	
	An_ = diagonal_sprites(An_, SpriteEND);
	An_ = transition_sprites(An_, SpriteEND);
	if quick_shoot: quick_shoot = false;
	
	if defeat:
		if !onFloor:
			An_ = 58;
			View_DW = false;
		else:
			An_ = 59;
			View_DW = false;
	
	if An_ != extra_comp && crouch_end:
		crouch_end = false;
	
	if An_ != extra_comp && crouch_start:
		crouch_start = false;
	
	if An_ != extra_comp && stoping_start || sit_state:
		stoping = false;
		stoping_start = false;
	
	if An_ != extra_comp && sit_shoot_idle_start:
		sit_shoot_idle = false;
		sit_shoot_idle_start = false;
	
	if An_ != throw_comp:
		start_throw = false;
	
	if An_ != shoot_comp:
		if buffer_shoot:
			start_buffer_shoot = true;
		else:
			start_shoot = false;
		dir_shoot = 0;
	elif start_buffer_shoot:
		start_buffer_shoot = false;
		buffer_shoot = false;
	
	if An_ != melee_comp:
		start_knife = false;
	
	return An_;

func sprite_animation_dw(An_, _SpriteEND):
	if onFloor:
		if (controles[0] || controles[1]) && !dir_change_start && !sit_state:
			An_ = 1;
		else:
			An_ = 0;
	else:
		if RunJump:
			An_ = 3;
		else:
			An_ = 2;
	return An_;

var CompCu = -1;
var CompAn = -1;
var heavy_count = 0;
func Events():
	projectiles = self.get_tree().get_nodes_in_group("Spawner")[0];
	if CompAn != An_UP:
		CompAn = An_UP;
		CompCu = -1;
	if CompCu != Current_UP && Mercenario && projectiles:
		CompCu = Current_UP;
		var DR = 1;
		if dir == 0: DR = -1;
		
		#hand_gun
		spawn_attack( 0,5,1,dir,Vector2(30*DR,-8) );
		spawn_attack( 0,14,1,dir,Vector2(30*DR,2) );
		spawn_attack( 0,9,1,2,Vector2(0*DR,-60) );
		spawn_attack( 0,11,1,3,Vector2(0*DR,30) );
		
		#H
		heavy_machine_gun(DR);
		
		#H-Diagonal-UP-up
		spawn_attack( 5,54,1,10*DR,Vector2(10*DR,-10) );
		spawn_attack( 5,54,3,11*DR,Vector2(10*DR,-10) );
		spawn_attack( 5,54,5,12*DR,Vector2(10*DR,-10) );
		spawn_attack( 5,54,7,13*DR,Vector2(10*DR,-10) );
		
		#H-Diagonal-UP-dw
		spawn_attack( 5,55,1,14*DR,Vector2(10*DR,-10) );
		spawn_attack( 5,55,3,15*DR,Vector2(10*DR,-10) );
		spawn_attack( 5,55,5,16*DR,Vector2(10*DR,-10) );
		
		#H-Diagonal-DOWN-dw
		spawn_attack( 5,56,1,20*DR,Vector2(10*DR,0) );
		spawn_attack( 5,56,3,21*DR,Vector2(10*DR,0) );
		spawn_attack( 5,56,5,22*DR,Vector2(10*DR,0) );
		spawn_attack( 5,56,7,23*DR,Vector2(10*DR,0) );
		
		#H-Diagonal-DOWN-up
		spawn_attack( 5,57,1,24*DR,Vector2(10*DR,0) );
		spawn_attack( 5,57,3,25*DR,Vector2(10*DR,0) );
		spawn_attack( 5,57,5,26*DR,Vector2(10*DR,0) );
		
		#2H
		two_machine_gun(0,DR);
		two_machine_gun(1,DR);
		
		var AN = 0;
		if weapon == 1:
			AN = 18*2;
		elif weapon == 2:
			AN = 18*1;
		
		#knife/baton
		var MC = Mercenario.cqc_config[0];
		spawn_attack( 1+MC,6+AN,3,dir,Vector2(0*DR,0) );
		spawn_attack( 1+MC,15+AN,3,dir,Vector2(0*DR,15) );
		MC = Mercenario.cqc_config[1];
		spawn_attack( 1+MC,7+AN,3,dir,Vector2(0*DR,0) );
		spawn_attack( 1+MC,16+AN,3,dir,Vector2(0*DR,15) );
		
		#bomb
		if bomb_ammo > 0:
			if !run_throw:
				spawn_attack( 3,8+AN,1,dir,Vector2(0*DR,-15) );
				spawn_attack( 3,17+AN,1,dir,Vector2(0*DR,0) );
			else:
				spawn_attack( 3,8+AN,1,dir+2,Vector2(0*DR,-15) );
				spawn_attack( 3,17+AN,1,dir+2,Vector2(0*DR,0) );

func spawn_attack(attack, An_, current_sprite, _dir, _pos):
	if An_UP == An_ && Current_UP == current_sprite:
		CompCu = Current_UP;
		_pos.x += self.position.x;
		_pos.y += self.position.y;
		projectiles.attack_queue.append([attack, _dir, _pos, true, IDJ]);
		
		match attack:
			5: pass;
			3:
				bomb_ammo -= 1;
				bomb_onScreen += 1;
			_: buffer_shoot = false;

func heavy_machine_gun(DR):
	for STF in range(1,9,2):
		spawn_attack( 5,23,STF,dir,Vector2(30*DR,-2) );
		spawn_attack( 5,32,STF,dir,Vector2(30*DR,2) );
		spawn_attack( 5,27,STF,2,Vector2(0*DR,-60) );
		spawn_attack( 5,29,STF,3,Vector2(0*DR,30) );

func two_machine_gun(index, DR):
	for STF in range(1,9,2):
		if index == 0:
			spawn_attack( 4,41,STF,dir,Vector2(30*DR,-8) );
			spawn_attack( 4,50,STF,dir,Vector2(30*DR,2) );
			spawn_attack( 4,45,STF,2,Vector2(0*DR,-60) );
			spawn_attack( 4,47,STF,3,Vector2(0*DR,30) );
		else:
			spawn_attack( 4,41,STF,dir,Vector2(30*DR,0) );
			spawn_attack( 4,50,STF,dir,Vector2(30*DR,10) );
			spawn_attack( 4,45,STF,2,Vector2(8*DR,-60) );
			spawn_attack( 4,47,STF,3,Vector2(8*DR,30) );

var rising = false;
var falling = false;
func vertical_momentum_detect():
	if !onFloor:
		if motion.y > 0:
			falling = true;
			rising = false;
		elif motion.y < 0:
			rising = true;
			falling = false;
	else:
		rising = false;
		falling = false;

func SpriteWork():
	#Changes de code of the animation
	An_UP = sprite_animation_up(An_UP, $Sprites/SpriteUP.SpriteEND);
	An_DW = sprite_animation_dw(An_DW, $Sprites/SpriteDW.SpriteEND);
	
	if walk_sync:
		var current = $Sprites/SpriteDW.current_sprite;
		$Sprites/SpriteUP.reset(current);
		$Sprites/SpriteDW.reset(current);
		$Sprites/SpriteUP.animation_select = An_UP;
		walk_sync = false;
	
	if( 
		re_shoot && (start_shoot || start_knife || start_throw) &&
		An_UP != 54 && An_UP != 55 && An_UP != 56 && An_UP != 57
	):
		var current = 0;
		$Sprites/SpriteUP.reset(current);
		re_shoot = false;
	
	$Sprites.IDM = IDM;
	$Sprites/SpriteUP.state = State_UP;
	#$Sprites/SpriteDW.state = State_DW;
	$Sprites/SpriteUP.visible = View_UP;
	$Sprites/SpriteDW.visible = View_DW;
	
	#Changes de animation
	An_UP = $Sprites.An_Sprites(An_UP,0);
	An_DW = $Sprites.An_Sprites(An_DW,1);
	Current_UP = $Sprites/SpriteUP.current_sprite;
	Current_DW = $Sprites/SpriteDW.current_sprite;
	Mercenario = $Sprites/SpriteUP.mercenario;

###############################################################################

var CompDF = 0;
func _physics_process(_delta):
	if !disabled:
		self.visible = true;
		onFloor = self.is_on_floor();
		motion.y += GRAVITY;
		vertical_momentum_detect();
		
		if HP <= 0 && CompDF == 0 && !invincible:
			CompDF = 1;
			if !onFloor: air_defeat = true;
			defeat = true;
			jump_force = true;
			disable_controls = true;
			onFloor = false;
		
		if !disable_controls:
			if controles[0]:
				if onFloor:
					if start_knife:
						pass;
					elif controles[2] && !start_shoot && !start_knife:
						turning(0);
					elif !controles[2]:
						turning(0);
					motion.x -= ACCEL;
				else:
					motion.x -= (JUMPACCEL-IJD);
			elif controles[1]:
				if onFloor:
					if start_knife || diagonal_start:
						pass;
					elif controles[2] && !start_shoot && !start_knife:
						turning(1);
					elif !controles[2]:
						turning(1);
					motion.x += ACCEL;
				else:
					motion.x += (JUMPACCEL-IJD);
			else:
				if onFloor:
					motion.x = 0;
				else:
					motion.x = lerp(motion.x, 0, 0.02);
		else:
			var TD = -1;
			if dir == 0: TD = 1;
			
			if onFloor:
				motion.x = 0;
			else:
				motion.x = TD*80;
		
		stop_animations_up(An_UP, $Sprites/SpriteUP.SpriteEND);
		Throwing();
		Jumping();
		Attacking();
		
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED;
		
		if Comp_D != dir:
			Comp_D = dir;
			self.scale.x = -1;
		
		if onFloor:
			if crouch_end || dir_change_start:
				motion.x = 0;
			elif controles[2]:
				if start_knife || start_throw || start_shoot:
					motion.x = 0;
				else:
					motion.x = clamp(motion.x, -CRAWLSPEED, CRAWLSPEED);
			else:
				motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED);
		else:
			motion.x = clamp(motion.x, -JUMPMAXSPEED, JUMPMAXSPEED);
		
		var snap;
		if FPS == 30: snap = Vector2.DOWN * 4;
		elif FPS == 60: snap = Vector2.DOWN * 2;
		motion = self.move_and_slide_with_snap(motion, snap, UP, true);
		
		SpriteWork();
		Crouch_HurtBox(sit_state);
		Events();
	else:
		self.visible = false;
		var target = self.get_tree().get_nodes_in_group("Camera")[0];
		self.position.x = target.true_pos().x+25+(25*IDJ);
		self.position.y = target.true_pos().y;
