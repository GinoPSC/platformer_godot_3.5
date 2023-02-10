extends "res://addons/godot-rollback-netcode/MessageSerializer.gd";

const input_path_mapping = {
	'/root/Network/Control_0' : 1,
	'/root/Network/Control_1' : 2,
	'/root/Network/Control_2' : 3,
	'/root/Network/Control_3' : 4
}

var input_path_mapping_reverse := {};

func _init():
	for key in input_path_mapping:
		input_path_mapping_reverse[input_path_mapping[key]] = key;

enum HeaderFlags {
	HAS_BUTTON_LEFT = 0x01,
	HAS_BUTTON_RIGHT = 0x02,
	HAS_BUTTON_DOWN = 0x04,
	HAS_BUTTON_UP = 0x08,
	HAS_BUTTON_BOMB = 0x01,
	HAS_BUTTON_JUMP = 0x02,
	HAS_BUTTON_SHOOT = 0x04,
	HAS_BUTTON_PAUSE = 0x08,
	HAS_BUTTON_ACTION = 0x10
}

func serialize_input(all_input: Dictionary) -> PoolByteArray:
	var buffer := StreamPeerBuffer.new();
	buffer.resize(16);
	
	buffer.put_u32(all_input['$']);
	buffer.put_u8(all_input.size()-1);
	
	for path in all_input:
		if path == '$':
			continue;
		buffer.put_u8(input_path_mapping[path]);
		
		var input = all_input[path];
		
		var directions := 0;
		var events := 0;
		if input.has('input_control'):
			for button in input["input_control"]:
				match button:
					0: directions |= HeaderFlags.HAS_BUTTON_LEFT;
					1: directions |= HeaderFlags.HAS_BUTTON_RIGHT;
					2: directions |= HeaderFlags.HAS_BUTTON_DOWN;
					3: directions |= HeaderFlags.HAS_BUTTON_UP
					4: events |= HeaderFlags.HAS_BUTTON_BOMB;
					5: events |= HeaderFlags.HAS_BUTTON_JUMP;
					6: events |= HeaderFlags.HAS_BUTTON_SHOOT;
					7: events |= HeaderFlags.HAS_BUTTON_PAUSE;
					8: events |= HeaderFlags.HAS_BUTTON_ACTION;
		buffer.put_u8(directions);
		buffer.put_u8(events);
		
		var directions_dw := 0;
		var events_dw := 0;
		if input.has('input_control_dw'):
			for button in input["input_control_dw"]:
				match button:
					0: directions_dw |= HeaderFlags.HAS_BUTTON_LEFT;
					1: directions_dw |= HeaderFlags.HAS_BUTTON_RIGHT;
					2: directions_dw |= HeaderFlags.HAS_BUTTON_DOWN;
					3: directions_dw |= HeaderFlags.HAS_BUTTON_UP
					4: events_dw |= HeaderFlags.HAS_BUTTON_BOMB;
					5: events_dw |= HeaderFlags.HAS_BUTTON_JUMP;
					6: events_dw |= HeaderFlags.HAS_BUTTON_SHOOT;
					7: events_dw |= HeaderFlags.HAS_BUTTON_PAUSE;
					8: events_dw |= HeaderFlags.HAS_BUTTON_ACTION;
		buffer.put_u8(directions_dw);
		buffer.put_u8(events_dw);
		
		var value_pos = Vector2(0,0);
		if input.has('position'):
			value_pos = input["position"];
		buffer.put_float(value_pos.x);
		buffer.put_float(value_pos.y);
		
		var value_mot = Vector2(0,0);
		if input.has('motion'):
			value_mot = input["motion"];
		buffer.put_float(value_mot.x);
		buffer.put_float(value_mot.y);
	
	buffer.resize(buffer.get_position());
	return buffer.data_array;

func unserialize_input(serialized: PoolByteArray) -> Dictionary:
	var buffer := StreamPeerBuffer.new();
	var error = buffer.put_data(serialized);
	if error: print (error);
	buffer.seek(0);
	
	var all_input := {};
	
	all_input['$'] = buffer.get_u32();
	
	var input_count = buffer.get_u8();
	if input_count == 0:
		return all_input;
	
	var path = input_path_mapping_reverse[buffer.get_u8()];
	var input := {};
	input['input_control'] = [];
	input['input_control_dw'] = [];
	
	var directions = buffer.get_u8();
	if directions & HeaderFlags.HAS_BUTTON_LEFT:
		input['input_control'].append(0);
	if directions & HeaderFlags.HAS_BUTTON_RIGHT:
		input['input_control'].append(1);
	if directions & HeaderFlags.HAS_BUTTON_DOWN:
		input['input_control'].append(2);
	if directions & HeaderFlags.HAS_BUTTON_UP:
		input['input_control'].append(3);
	
	var events = buffer.get_u8();
	if events & HeaderFlags.HAS_BUTTON_BOMB:
		input['input_control'].append(4);
	if events & HeaderFlags.HAS_BUTTON_JUMP:
		input['input_control'].append(5);
	if events & HeaderFlags.HAS_BUTTON_SHOOT:
		input['input_control'].append(6);
	if events & HeaderFlags.HAS_BUTTON_PAUSE:
		input['input_control'].append(7);
	if events & HeaderFlags.HAS_BUTTON_ACTION:
		input['input_control'].append(8);
	
	
	var directions_dw = buffer.get_u8();
	if directions_dw & HeaderFlags.HAS_BUTTON_LEFT:
		input['input_control_dw'].append(0);
	if directions_dw & HeaderFlags.HAS_BUTTON_RIGHT:
		input['input_control_dw'].append(1);
	if directions_dw & HeaderFlags.HAS_BUTTON_DOWN:
		input['input_control_dw'].append(2);
	if directions_dw & HeaderFlags.HAS_BUTTON_UP:
		input['input_control_dw'].append(3);
	
	var events_dw = buffer.get_u8();
	if events_dw & HeaderFlags.HAS_BUTTON_BOMB:
		input['input_control_dw'].append(4);
	if events_dw & HeaderFlags.HAS_BUTTON_JUMP:
		input['input_control_dw'].append(5);
	if events_dw & HeaderFlags.HAS_BUTTON_SHOOT:
		input['input_control_dw'].append(6);
	if events_dw & HeaderFlags.HAS_BUTTON_PAUSE:
		input['input_control_dw'].append(7);
	if events_dw & HeaderFlags.HAS_BUTTON_ACTION:
		input['input_control_dw'].append(8);
	
	var value_pos = Vector2(0,0);
	value_pos.x = buffer.get_float();
	value_pos.y = buffer.get_float();
	input["position"] = value_pos;
	
	var value_mot = Vector2(0,0);
	value_mot.x = buffer.get_float();
	value_mot.y = buffer.get_float();
	input["motion"] = value_mot;
	
	all_input[path] = input;
	return all_input;
