extends KinematicBody2D;
var FPS = Engine.get_iterations_per_second();

var direction = 1;
var IDJ = 0;
var spin_dir = 1;
var time = 0;
var jumps = 1;
var speed = 20;
var dist = 50;

var GRAVITY = 20;
const MAXFALLSPEED = 200;
const JUMPFORCE = 150;
const THROWFORCE = 80;
const BOUNCEFORCE = 200;
var motion = Vector2(0,0);
var extra_speed = 0;

func _ready():
	if FPS == 60: GRAVITY /= 2;
		
	if direction == 0 || direction == 2:
		spin_dir = -1;
	elif direction == 1 || direction == 3:
		spin_dir = 1;
	if direction > 1: extra_speed = 4;
	motion.y = -JUMPFORCE;
	motion.x = THROWFORCE*spin_dir;
	speed = 4+extra_speed;
	dist = 35;

var rising = false;
var falling = false;
func vertical_momentum_detect():
	if motion.y > 0:
		falling = true;
		rising = false;
	elif motion.y < 0:
		rising = true;
		falling = false;

var delete_this = false;
var explode = false;
var enemy_hit = false;
var cooldown = false;
var c_tick = 0;
var CompEX = 0;
func _physics_process(delta):
	if !explode:
		vertical_momentum_detect();
		motion.y += GRAVITY;
		if motion.y > MAXFALLSPEED:
			motion.y = MAXFALLSPEED;
		
		var info = self.move_and_collide(motion * delta);
		if info:
			cooldown = true;
			motion = motion.bounce(info.normal);
			motion.x *= 1.5;
			motion.y *= 0.8;
			motion.x = clamp(motion.x, -BOUNCEFORCE, BOUNCEFORCE);
		if cooldown && jumps > 0:
			if c_tick > 3:
				jumps = -1;
				cooldown = false;
			c_tick += 1;
		elif cooldown:
			explode = true;
		
		if time > 1:
			dist = dist/1.1;
			time = 0;
		time += 1;
		
		self.rotation_degrees += dist*spin_dir;
		if rising && jumps > 0:
			speed = speed/1.1;
			self.position.x += speed*spin_dir;
	elif CompEX == 0:
		$Bomb/Sprite.visible = false;
		self.rotation_degrees = 0;
		var shape = RectangleShape2D.new();
		shape.set_extents(Vector2(30, 50));
		$Bomb/HitBox.set_shape(shape);
		$Bomb.position.y -= 40;
		var target = self.get_tree().get_nodes_in_group("Spawner")[4];
		if target: target.sfx_queue.append(
			[0, Vector2(self.position.x, self.position.y-40), true]
		);
		CompEX = 1;
	else:
		delete_this = true;
		CompEX = 2;
	
	for enemy in $Bomb.get_overlapping_bodies():
		if CompEX != 1:
			if "Enemy Type" in enemy.name:
				if !enemy.e_body.defeat:
					if explode:
						enemy.e_body.damage_type = 3;
						enemy.e_body.range_hit = true;
						enemy.e_body.damage += 60;
						enemy_hit = true;
					else:
						explode = true;
	
	if delete_this:
		var personaje = self.get_tree().get_nodes_in_group("Character")[IDJ];
		personaje.bomb_onScreen -= 1;
		if enemy_hit:
			personaje.score += 100;
		self.queue_free();
