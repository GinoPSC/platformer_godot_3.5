extends Sprite;

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

var sprite_config = mercenarios[IDM].sprite_config_dw;
var sprite_position = mercenarios[IDM].sprite_pos_dw;

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
		self.set_texture(mercenarios[IDM].sprite_sheet_dw);
		sprite_config = mercenarios[IDM].sprite_config_dw;
	
	var confguration = sprite_config[animation_select][1];
	var animation_chain = sprite_config[animation_select][0];
	var animated_frame = animation_chain[current_sprite][0];
	self.position.x = confguration[0];
	self.position.y = confguration[1];
	self.region_rect.position.x = 11+(60*animated_frame);
	self.region_rect.position.y = 11+sprite_position[animation_select];

func _ready():
	pass;
