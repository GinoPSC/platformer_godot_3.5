extends Node2D;

var sfx_route = load("res://resources/Objects/SFX.tscn");
func _ready():
	pass;

func spawn_effect(effect, pos):
	var sfx = sfx_route.instance();
	sfx.position = pos;
	sfx.effect = effect;
	self.add_child(sfx);

var target = null;
var sfx_queue = [];
func _physics_process(_delta):
	target = self.get_tree().get_nodes_in_group("Camera")[0];
	if target:
		for request in sfx_queue:
			if request[2] && target.true_pos().x+350 >= request[1].x:
				request[2] = false;
				spawn_effect(request[0], request[1]);
