extends CollisionShape2D;

var direction = 0;
var type = 0;
var HP = 1;
var damage = 0;
var damage_type = 0;
var defeat = false;
var range_hit = false;
var melee_hit = false;
var ghost = false;
var delete = false;
func _ready():
	pass;

func setHitBox(box):
	var shape = RectangleShape2D.new();
	shape.set_extents(Vector2(box.size.x, box.size.y));
	self.set_shape(shape);
	self.position = Vector2(box.position.x, box.position.y);

func _physics_process(_delta):
	if range_hit:
		range_hit = false;
		
	if melee_hit:
		melee_hit = false;
		if type == 1:
			damage = 0;
	HP -= damage;
	damage = 0;
	
	if HP <= 0:
		defeat = true;
	
	if defeat:
		#ghost = true;
		pass;
	
	if delete:
		self.get_parent().queue_free();
