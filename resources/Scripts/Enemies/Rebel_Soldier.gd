extends Abstract_Enemy;

const route_sprite = "res://resources/Sprites/Enemies/Rebel_Soldier/body.png";
const route_config = "res://resources/Scripts/Enemies/Rebel_Soldier_Config.gd";
const sprite_sheet = preload(route_sprite);
const config_ = preload(route_config);
func _ready():
	init_body();
	set_texture(sprite_sheet, Rect2(11,11,48,48));
	set_config(config_, 0, Rect2(0,2,8,18), 1, false);
	add_child(e_body);
	add_child(e_texture);

func enemy_attack(dir):
	var attack = self.get_tree().get_nodes_in_group("Spawner")[1];
	var Vpos = Vector2(self.position.x+(5*dir), self.position.y-15);
	attack.enemy_attack_queue.append([2, target_player.IDJ, Vpos, true]);

var air_death = false;
var insta_death = false;
var attacking = 0;
func _physics_process(_delta):
	call_physics_process();
	if An_E == 12:
		insta_death = true;
	
	if onFloor && !all_defeat:
		if attacking < 100:
			attacking += 1;
	
	if !onFloor:
		if e_body.defeat:
			if e_body.damage_type == 1:
				An_E = 12;
			else:
				An_E = 8;
				air_death = true;
		else:
			An_E = 5;
	else:
		if e_body.defeat:
			if e_body.damage_type == 1:
				An_E = 12;
			elif air_death:
				An_E = 9;
			else: An_E = 6;
			if e_texture.SpriteEND:
				if insta_death:
					e_body.delete = true;
				e_body.ghost = true;
		else:
			if attacking >= 100:
				An_E = 14;
				if e_texture.current_sprite == 1 && e_texture.sprite_time == 0:
					if target_player_dir == -1:
						e_texture.scale.x = 1;
						self.direction = 0;
					else:
						e_texture.scale.x = -1;
						self.direction = 1;
				if e_texture.current_sprite == 10 && e_texture.sprite_time == 0:
					enemy_attack(-1);
			else:
				An_E = 0;
			if e_texture.SpriteEND:
				if An_E == 14:
					attacking = 0;
	
	e_texture.update_sprite(An_E);
	pass;
