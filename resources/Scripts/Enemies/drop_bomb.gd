extends Abstract_Object;

func _ready():
	call_ready();

func _physics_process(_delta):
	self.call_physics_process();
	
	var chain = [
		[0,0],[1,0],[2,0],[1,0]
	];
	$Sprite.region_rect = animate_sprite(
		sprite_region.position,
		sprite_region.size,
		true,0,chain
	);
	
	var player_hit = self.detect_collision_with("Personaje");
	
	if onFloor || player_hit:
		delete_this = true;
