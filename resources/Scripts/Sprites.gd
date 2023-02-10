extends TextureRect;
var FPS = Engine.get_iterations_per_second();

var IDM = 0;
func _ready():
	pass;

func An_Sprites(ans, sheet):
	var selected_sheet;
	match sheet:
		0: selected_sheet = $SpriteUP;
		1: selected_sheet = $SpriteDW;
	
	var animation_select = selected_sheet.animation_select;
	var current_sprite = selected_sheet.current_sprite;
	var sprite_time = selected_sheet.sprite_time;
	var SpriteEND = selected_sheet.SpriteEND;
	var confguration = selected_sheet.sprite_config[ans][1];
	var animation_chain = selected_sheet.sprite_config[ans][0];
	if animation_select != ans:
		animation_select = ans;
		current_sprite = 0;
		sprite_time = 0;
		SpriteEND = false;
	
	if !SpriteEND:
		var end_frame = animation_chain.size()-1;
		var repeat = confguration[4];
		var repeat_frame = confguration[5];
		if current_sprite > animation_chain.size():
			current_sprite = animation_chain.size();
			print (current_sprite);
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
	
	selected_sheet.update_sprite(
		animation_select,
		current_sprite,
		sprite_time,
		SpriteEND,
		IDM
	);
	
	return animation_select;
