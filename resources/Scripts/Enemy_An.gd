extends Sprite;
var FPS = Engine.get_iterations_per_second();

func _ready():
	self.region_enabled = true;

var sprite_config = [];
var animation_select = 0;
var current_sprite = 0;
var sprite_time = 0;
var SpriteEND = false;
func update_sprite(an):
	if animation_select != an:
		animation_select = an;
		current_sprite = 0;
		sprite_time = 0;
		SpriteEND = false;
	
	var confguration = sprite_config[animation_select][1];
	var animation_chain = sprite_config[animation_select][0];
	var animated_frame = animation_chain[current_sprite][0];
	self.position.x = confguration[0];
	self.position.y = confguration[1];
	self.region_rect.size.x = confguration[2]-2;
	self.region_rect.size.y = confguration[3]-2;
	self.region_rect.position.x = 11+((confguration[2]+10)*animated_frame);
	self.region_rect.position.y = 11+confguration[6];
	
	if !SpriteEND:
		var end_frame = animation_chain.size()-1;
		var repeat = confguration[4];
		var repeat_frame = confguration[5];
		var speed_frame = animation_chain[current_sprite][1];
		if FPS == 60:
			if speed_frame == 0: speed_frame = 1;
			else: speed_frame *= 2;
		if sprite_time == speed_frame:
			sprite_time = 0;
			if current_sprite == end_frame:
				if repeat:
					current_sprite = repeat_frame;
				else:
					SpriteEND = true;
			else:
				current_sprite += 1;
		else:
			sprite_time += 1;

var dis_time = 0;
var dis_count = 0;
var dis_state = true;
func dissapearing():
	if dis_time > 0 || FPS == 30:
		if dis_count > 20:
			if dis_state:
				self.self_modulate.a = 0.7;
			else:
				self.self_modulate.a = 0.5;
			dis_state = !dis_state;
			dis_time = 0;
		dis_count += 1;
	else: dis_time += 1;

var glow = 0;
var glo_turn = 0;
var glo_time = 0;
var glo_count = 0;
var glo_state = true;
func hit_glowing():
	if glo_time > 0 || FPS == 30:
		if glo_count < 6:
			if glo_state:
				self.self_modulate.r = 1;
				self.self_modulate.g = 1;
				self.self_modulate.b = 1;
			else:
				if glo_turn == 0:
					self.self_modulate.g = 0;
					self.self_modulate.b = 0;
				elif glo_turn == 1:
					self.self_modulate.b = 0;
				elif glo_turn == 2:
					self.self_modulate.r = 0;
					self.self_modulate.g = 0;
				glo_turn += 1;
				if glo_turn > 2: glo_turn = 0;
			glo_state = !glo_state;
			glo_time = 0;
			glo_count += 1;
		else:
			glow = 0;
			self.self_modulate.r = 1;
			self.self_modulate.g = 1;
			self.self_modulate.b = 1;
			glo_time = 0;
			glo_count = 0;
			glo_state = true;
	else: glo_time += 1;

func get_modulate():
	return self.self_modulate;
