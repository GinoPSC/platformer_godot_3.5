extends KinematicBody2D; class_name Abstract_Object
var FPS = Engine.get_iterations_per_second();

const UP = Vector2(0,-1);
const GRAVITY = 10;
const MAXFALLSPEED = 170;

var sprite_region:Rect2;
func call_ready():
	sprite_region = $Sprite.region_rect;
	var hurt_box = Rect2(
		$CollisionShape2D.position,
		$CollisionShape2D.shape.extents
	);
	enable_detection(hurt_box);

var detection_area:Area2D;
func enable_detection(box):
	var shape = RectangleShape2D.new();
	shape.set_extents(box.size);

	var collision = CollisionShape2D.new();
	collision.set_shape(shape);
	
	detection_area = Area2D.new();
	detection_area.set_collision_layer_bit(1,false);
	detection_area.add_child(collision);
	
	add_child(detection_area);

func detect_collision_with(object):
	if detection_area:
		for body in detection_area.get_overlapping_bodies():
			if object in body.name:
				if body.defeat: return false;
				body.HP -= 1;
				return true;
	return false;

var target = -1;
var target_player = 0;
var target_player_dir = -1;
var target_player_distance = Vector2(0,0);
var target_player_position = Vector2(0,0);
var cant_player = 0;
var last = 0;
var all_defeat = true;
func target_player_pos(tar = -1):
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
			if tar >= 0: target_player = players[tar];
			if all_defeat: target_player = players[last];
		if self.position.x > target_player.position.x:
			target_player_dir = -1;
		else: target_player_dir = 1;
		target_player_distance.x = lerp(target_player.position.x, self.position.x, 1);
		target_player_distance.x -= target_player.position.x;
		return target_player.position;
	else:
		return null;

var current_sprite = 0;
var sprite_time = 0;
var SpriteEND = false;
func animate_sprite(sp_pos:Vector2, sp_sz:Vector2, repeat, repeat_frame, animation_chain):
	if !SpriteEND:
		var end_frame = animation_chain.size()-1;
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
	
	var sp_rect = Rect2(0,0,0,0);
	sp_rect.size.x = sp_sz.x;
	sp_rect.size.y = sp_sz.y;
	sp_rect.position.x = 11+((sp_sz.x+12)*animation_chain[current_sprite][0]);
	sp_rect.position.y = sp_pos.y;
	
	return sp_rect;

var motion = Vector2();
var onFloor = false;
var canFly = false;
var delete_this = false;
func call_physics_process():
	if delete_this:
		self.queue_free();
	
	onFloor = self.is_on_floor();
	target_player_position = target_player_pos(target);
	
	if !canFly:
		motion.y += GRAVITY;
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED;
	
	if !canFly:
		if FPS == 30:
			motion /= 1.1;
		var snap = Vector2.DOWN * 2;
		motion = self.move_and_slide_with_snap(motion, snap, UP, true);
	else:
		motion = self.move_and_slide(motion, UP);
