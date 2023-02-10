extends Abstract_Enemy;

const route_sprite = "res://resources/Sprites/Enemies/R_Shobu/shobu.png";
const route_config = "res://resources/Scripts/Enemies/R_Shobu_Config.gd";
const sprite_sheet = preload(route_sprite);
const config_ = preload(route_config);
func _ready():
	init_body();
	set_texture(sprite_sheet, Rect2(11,11,108,108));
	set_config(config_, 1, Rect2(0,0,35,10), 200, true);
	add_child(e_body);
	add_child(e_texture);
	self.move_child(e_body, 0);

var shoot_shobu = 0;
var amount = 0;
var cooldown = 0;
func drop_bombs():
	if shoot_shobu > 50:
		if cooldown <= 0:
			if amount < 3:
				var attack = self.get_tree().get_nodes_in_group("Spawner")[1];
				attack.enemy_attack_queue.append([0, target_player.IDJ, self.position, true]);
				amount += 1;
				cooldown = 10;
			else:
				shoot_shobu = 0;
				amount = 0;
		else: cooldown -= 1;
	else: shoot_shobu += 1;

var heli_x = 0;
var shobu_speed = 0;
func _physics_process(_delta):
	call_physics_process();
	drop_bombs();
	
	var followSpeed = lerp(self.position.x, target_player_pos().x, 0.02);
	if shobu_speed == 0:
		shobu_speed = followSpeed;
	else:
		var _speed = 0;
		if shobu_speed > followSpeed:
			_speed = shobu_speed-followSpeed;
		elif shobu_speed < followSpeed:
			_speed = followSpeed-shobu_speed;
		shobu_speed = followSpeed;
		var TD = target_player_dir;
		if _speed > 0.5:
			self.rotation_degrees = lerp(0, _speed, 3) * TD;
		else: self.rotation_degrees = 0;
	self.position.x = followSpeed;
	if !onFloor:
		if e_body.defeat:
			An_E = 0;
			e_body.delete = true;
		else:
			An_E = 0;
	else:
		if e_body.defeat:
			An_E = 0;
			e_body.delete = true;
		else:
			An_E = 0;
	e_texture.update_sprite(An_E);
	
	if e_body.delete:
		var target = self.get_tree().get_nodes_in_group("Spawner")[4];
		if target: target.sfx_queue.append(
			[2, Vector2(self.position.x+5, self.position.y-30), true]
		);
	if heli_x < 5:
		heli_x += 1;
	else: heli_x = 0;
	$Sprite.region_rect.position.x = 11+((110+10)*heli_x);
	$Sprite.self_modulate = e_texture.get_modulate();
