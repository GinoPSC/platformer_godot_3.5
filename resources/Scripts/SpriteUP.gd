extends Sprite;
var FPS = Engine.get_iterations_per_second();

var mercenarios = [
	preload("res://resources/Scripts/Characters/1_marco.gd"),
	preload("res://resources/Scripts/Characters/2_tarma.gd"),
	preload("res://resources/Scripts/Characters/3_eri.gd"),
	preload("res://resources/Scripts/Characters/4_fio.gd"),
	preload("res://resources/Scripts/Characters/5_trevor.gd"),
	preload("res://resources/Scripts/Characters/6_nadia.gd"),
	preload("res://resources/Scripts/Characters/7_ralf.gd"),
	preload("res://resources/Scripts/Characters/8_clark.gd"),
	preload("res://resources/Scripts/Characters/9_leona.gd")
];

var animation_select = 0;
var current_sprite = 0;
var sprite_time = 0;
var SpriteEND = false;
var IDM = 0;
var CompIDM = 0;
var state = 0;
var extra_x = 0;
var extra_y = 0;

var mercenario = null;
var sprite_state = null;
var sprite_config = null;
var sprite_position = null;
func _ready():
	mercenario = mercenarios[IDM];
	sprite_state = mercenario.state_config_up;
	sprite_config = mercenario.sprite_config_up;
	sprite_position = mercenario.sprite_pos_up;

func reset(current = 0):
	current_sprite = current;
	sprite_time = 0;
	SpriteEND = false;

func update_sprite(an, cu, st, se, idm):
	animation_select = an;
	current_sprite = cu;
	sprite_time = st;
	SpriteEND = se;
	IDM = idm;
	
	if CompIDM != IDM:
		CompIDM = IDM;
		mercenario = mercenarios[IDM];
		sprite_state = mercenario.state_config_up;
		sprite_config = mercenario.sprite_config_up;
		self.set_texture(mercenario.sprite_sheet_up);
	
	
	var spc = [8,0];
	if state > 4:
		if Comp_S != state:
			Comp_S = state;
			time = 0;
		var chain = sprite_state[state];
		time = special_animation(chain, spc[state-5]);
	else:
		extra_x = sprite_state[state][0];
		extra_y = sprite_state[state][1];
		time = 0;
	
	var confguration = sprite_config[animation_select][1];
	var animation_chain = sprite_config[animation_select][0];
	var animated_frame = animation_chain[current_sprite][0];
	self.position.x = confguration[0]+extra_x;
	self.position.y = confguration[1]+extra_y;
	self.region_rect.size.x = confguration[2]-2;
	self.region_rect.size.y = confguration[3]-2;
	self.region_rect.position.x = 11+((confguration[2]+10)*animated_frame);
	self.region_rect.position.y = 11+sprite_position[animation_select];

var Comp_S = 0;
var time = 0;
func special_animation(chain, repeat):
	extra_x = chain[time][0];
	extra_y = chain[time][1];
	time += 1;
	if FPS == 30:
		time += 1;
	if time > chain.size()-1:
		time = repeat;
	return time;
