extends KinematicBody2D; class_name Abstract_Enemy

const UP = Vector2(0,-1);
const GRAVITY = 12;
const MAXFALLSPEED = 170;

var direction = 0;
var e_body:CollisionShape2D;
func init_body():
	self.name = "Enemy Type";
	e_body = CollisionShape2D.new();
	e_body.set_position(Vector2(0,0));
	e_body.name = "HitBox";
	var body_script = load("res://resources/Scripts/Enemy_Type_1.gd");
	e_body.set_script(body_script);

var e_texture = Sprite.new();
func set_texture(sheet, region):
	e_texture.set_texture(sheet);
	e_texture.region_rect = region;
	e_texture.name = "Sprite";
	var texture_script = load("res://resources/Scripts/Enemy_An.gd");
	e_texture.set_script(texture_script);

func set_config(conf, type, box, hp, fly):
	e_body.type = type;
	e_body.setHitBox(box);
	e_body.HP = hp;
	e_texture.sprite_config = conf.SpriteConfig;
	canFly = fly;

var target_player = 0;
var target_player_dir = -1;
var target_player_distance = Vector2(0,0);
var target_player_position = Vector2(0,0);
var cant_player = 0;
var last = 0;
var all_defeat = true;
func target_player_pos():
	var players = self.get_tree().get_nodes_in_group("Character");
	if players:
		all_defeat = true;
		for pl in players:
			if !pl.defeat && !pl.disabled:
				all_defeat = false;
				last = pl.IDJ;
		
		var defeat = false;
		if target_player:
			if target_player.defeat || target_player.disabled:
				defeat = true;
		if cant_player != players.size() || defeat:
			cant_player = players.size();
			var rng = RandomNumberGenerator.new();
			rng.randomize();
			var my_random_number = rng.randf_range(0, cant_player);
			target_player = players[my_random_number];
			if all_defeat: target_player = players[last];
		if self.position.x > target_player.position.x:
			target_player_dir = -1;
		else: target_player_dir = 1;
		target_player_distance.x = lerp(target_player.position.x, self.position.x, 1);
		target_player_distance.x -= target_player.position.x;
		return target_player.position;
	else:
		return null;

var bounce = false;
var e_bounce:Area2D = null;
func bounce_player():
	if e_body.defeat:
		e_bounce.queue_free();
		e_bounce = null;
		bounce = false;
	elif e_bounce:
		for player in e_bounce.get_overlapping_bodies():
			if "Personaje" in player.name:
				player.jump_force = true;
				if self.position.x > player.position.x:
					player.motion.x = -player.JUMPMAXSPEED;
				else:
					player.motion.x = player.JUMPMAXSPEED;
	elif bounce:
		e_bounce = Area2D.new();
		var collision = CollisionShape2D.new();
		var shape = RectangleShape2D.new();
		shape.set_extents(e_body.shape.extents);
		collision.set_shape(shape);
		collision.position = e_body.position;
		self.add_child(e_bounce);
		e_bounce.add_child(collision);

var motion = Vector2();
var onFloor = false;
var canFly = false;
var An_E = 0;
func call_physics_process():
	onFloor = self.is_on_floor();
	target_player_position = target_player_pos();
	
	if !canFly:
		motion.y += GRAVITY;
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED;
	
	if !canFly:
		var snap = Vector2.DOWN * 2;
		motion = self.move_and_slide_with_snap(motion, snap, UP, true);
	else:
		motion = self.move_and_slide(motion, UP);
	
	if bounce:
		bounce_player();
	
	if e_body.range_hit:
		if e_body.type == 1: e_texture.glow = 1;
	
	if e_texture.glow > 0:
		e_texture.hit_glowing();
	
	if e_body.ghost:
		e_texture.dissapearing();
		if e_texture.dis_count > 30: e_body.delete = true;
