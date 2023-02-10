extends Camera2D;
var FPS = Engine.get_iterations_per_second();

var targets = [];
var selected_target = null;
var direction = 1;
const CAMERASPEED = 0.5;
const CAMERASPEEDLIMIT = 1;
var CAMERAACCEL = 0.1;

func _ready():
	if FPS == 30:
		CAMERAACCEL = 0.4;
	self.offset_v = -1.5;
	#self.offset_h = 1;

var Native_Resolution = Vector2(300,224);
func true_pos():
	var pos = Vector2(0,0);
	pos.x = self.get_camera_position().x - 150;
	pos.y = self.get_camera_position().y - 112;
	
	if pos.x < self.limit_left:
		pos.x = self.limit_left;
		
	if pos.x > self.limit_right-Native_Resolution.x:
		pos.x = self.limit_right-Native_Resolution.x;
	
	if pos.y < self.limit_top:
		pos.y = self.limit_top;
	
	if pos.y > self.limit_bottom-Native_Resolution.y:
		pos.y = self.limit_bottom-Native_Resolution.y;
	
	return pos;

var last = 0;
func pos_select():
	targets = self.get_tree().get_nodes_in_group("Character");
	
	var all_defeat = true;
	if targets:
		var tar_x = [];
		var tar_y = [];
		for target in targets:
			if !target.defeat && !target.disabled:
				tar_x.append(target.position.x);
				tar_y.append(target.IDJ);
				all_defeat = false;
				last = target.IDJ;
		
		if !all_defeat:
			var top_pos = tar_x.max();
			var idx_top = tar_x.find(top_pos);
			selected_target = targets[tar_y[idx_top]];
		else: selected_target = targets[last];

var offset_x = self.offset_h;
var offset_y = self.offset_v;
func _physics_process(_delta):
	pos_select();
	
	if selected_target:
		if FPS == 30:
			self.position.x = lerp(self.position.x, selected_target.position.x, 0.2);
		elif FPS == 60:
			self.position.x = lerp(self.position.x, selected_target.position.x, 0.1);
		var ejey = selected_target.position.y;
		if selected_target.onFloor:
			self.position.y = lerp(self.position.y, ejey, 0.05);
		elif selected_target.falling:
			self.position.y = lerp(self.position.y, ejey+40, 0.02);
		
		if selected_target.dir == 0 && -CAMERASPEED < self.offset_h:
			offset_x -= CAMERAACCEL;
			if offset_x < -CAMERASPEEDLIMIT: offset_x = -CAMERASPEEDLIMIT;
		elif selected_target.dir == 1 && self.offset_h < CAMERASPEED:
			offset_x += CAMERAACCEL;
			if CAMERASPEEDLIMIT < offset_x: offset_x = CAMERASPEEDLIMIT;
		
		if FPS == 30:
			self.offset_h = lerp(self.offset_h, offset_x, 0.04);
		elif FPS == 60:
			self.offset_h = lerp(self.offset_h, offset_x, 0.02);
