extends Node2D;

var sfx_route = load("res://resources/Objects/Item.tscn");
func _ready():
	pass;

func spawn_item(item, pos):
	var object = sfx_route.instance();
	object.position = pos;
	object.item = item;
	self.add_child(object);

var target = null;
var item_queue = [];
func _physics_process(_delta):
	target = self.get_tree().get_nodes_in_group("Camera")[0];
	if target:
		for request in item_queue:
			if request[2] && target.true_pos().x+350 >= request[1].x:
				request[2] = false;
				spawn_item(request[0], request[1]);
