extends PanelContainer;

var Num = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0]
];

const Default_Num = [
	[16777231, 16777233, 16777234, 16777232, 90, 88, 67, 32, 86],
	[65, 68, 83, 87, 85, 73, 79, 16777351, 80],
	[66, 77, 78, 72, 49, 50, 51, 16777352, 52],
	[82, 89, 84, 53, 55, 56, 57, 16777353, 48]
];

var default_controllers = true;
var network_controllers = false;
var IDJ = 0;

func _ready():
	if default_controllers:
		Num[IDJ] = Default_Num[IDJ];
	self.name = "Control_"+str(IDJ);

var controles = [
	false, false, false, false, false, false, false, false, false
];

var net_controles = [
	false, false, false, false, false, false, false, false, false
];

const Windows_Size = Vector2(300,224);
const MaxScale = 3;
const MinScale = 1;
var Windows_Scale = 1;

func _input(event):
	if Input.is_action_just_pressed("FullScreen"):
		OS.window_fullscreen = !OS.window_fullscreen;
	
	if Input.is_action_just_pressed("Native"):
		Windows_Scale = 1;
	elif Input.is_action_just_pressed("ScaleDW"):
		Windows_Scale -= 1;
		if Windows_Scale <= MinScale:
			Windows_Scale = MinScale;
	elif Input.is_action_just_pressed("ScaleUP"):
		Windows_Scale += 1;
		if Windows_Scale >= MaxScale:
			Windows_Scale = MaxScale;
	if (
		Input.is_action_just_pressed("Native") ||
		Input.is_action_just_pressed("ScaleDW") ||
		Input.is_action_just_pressed("ScaleUP")
	):
		OS.window_size.x = Windows_Size.x * Windows_Scale;
		OS.window_size.y = Windows_Size.y * Windows_Scale;
	
	if event.is_pressed() && event is InputEventJoypadButton:
		#print("event: ", event.button_index);
		pass;
	
	if event.is_pressed() && event is InputEventJoypadMotion:
		#print("event: ", event.axis, ", ", event.axis_value);
		pass;
	
	if event.is_pressed() && event is InputEventKey:
		#print("event: ", event.scancode);
		for y in 9:
			if event.scancode == Num[IDJ][y]:
				controles[y] = true;
	elif !event.is_pressed() && event is InputEventKey:
		for y in 9:
			if event.scancode == Num[IDJ][y]:
				controles[y] = false;

#NETWORK
var comp_control = [
	false, false, false, false, false, false, false, false, false
];
func _get_local_input() -> Dictionary:
	var input_control = [];
	var input_control_dw = [];
	
	for x in 9:
		if comp_control[x] != controles[x]:
			comp_control[x] = controles[x];
			if controles[x]:
				input_control.append(x);
			elif !controles[x]:
				input_control_dw.append(x);
		
		net_controles[x] = false;
		if controles[x]:
			net_controles[x] = true;
	
	var input := {}
	if input_control.size() != 0:
		input["input_control"] = input_control;
	
	if input_control_dw.size() != 0:
		input["input_control_dw"] = input_control_dw;
	
#	var characters = self.get_tree().get_nodes_in_group("Character");
#	input["position"] = characters[IDJ].get_character_state()[0];
#	input["motion"] = characters[IDJ].get_character_state()[1];
	
	return input;

func _network_process(input: Dictionary):
	if input.get("input_control"):
		for button in input["input_control"]:
			net_controles[button] = true;
	
	if input.get("input_control_dw"):
		for button in input["input_control_dw"]:
			net_controles[button] = false;
	
	var characters = self.get_tree().get_nodes_in_group("Character");
	if input.get("position"):
		characters[IDJ].position = input["position"];
	if input.get("motion"):
		characters[IDJ].motion = input["motion"];
	
func _save_state() ->Dictionary:
	return {
		left = net_controles[0],
		right = net_controles[1],
		down = net_controles[2],
		up = net_controles[3],
		bomb = net_controles[4],
		jump = net_controles[5],
		shoot = net_controles[6],
		pause = net_controles[7],
		action = net_controles[8]
	}

func _load_state(state: Dictionary):
	net_controles[0] = state['left'];
	net_controles[1] = state['right'];
	net_controles[2] = state['down'];
	net_controles[3] = state['up'];
	net_controles[4] = state['bomb'];
	net_controles[5] = state['jump'];
	net_controles[6] = state['shoot'];
	net_controles[7] = state['pause'];
	net_controles[8] = state['action'];
