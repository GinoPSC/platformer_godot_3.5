extends CanvasLayer;

var controles_ruta = load("res://resources/Objects/Controles.tscn");
var game_ruta = "res://resources/Objects/GameScreen.tscn";
var network_ruta = "res://resources/Objects/Network.tscn";
var cantidad_jugadores = 4;

var input_controles = [];
func _ready():
	Engine.set_iterations_per_second(60);
	$transition_1.visible = false;
	$transition_2.visible = false;
	$Menu.visible = false;
	for x in cantidad_jugadores:
		var player_controles = controles_ruta.instance();
		player_controles.set_position(Vector2(0,0));
		player_controles.default_controllers = true;
		player_controles.IDJ = x;
		add_child(player_controles);
		input_controles.append(player_controles.controles);

var menu = 0;
var game_screen = false;
var network_screen = false;
var comp_gs = 0;
var comp_sg = 0;
var comp_up = 0;
var comp_dw = 0;
var start_time = 0;
var step = 0;
var option = 0;
var FPS30 = false;
func _physics_process(_delta):
	if game_screen && comp_gs == 0:
		comp_gs = 1;
		if get_tree().change_scene(game_ruta):
			print("Game scene time out");
		self.queue_free();
	elif network_screen && comp_gs == 0:
		comp_gs = 1;
		if get_tree().change_scene(network_ruta):
			print("Game scene time out");
		self.queue_free();
	elif !game_screen && !network_screen:
		
		#menu
		if menu == 0:
			if start_time > 70:
				if step == 0:
					$s_Text/press_start.visible = true;
					$s_Text/s_ps.visible = true;
					start_time = 0;
					step = 1;
				else:
					$s_Text/press_start.visible = false;
					$s_Text/s_ps.visible = false;
					start_time = 30;
					step = 0;
			else: start_time += 1;
		elif menu == 1:
			$transition_1.visible = true;
			$Menu.visible = true;
			$s_Text.visible = false;
			if FPS30:
				$Menu/fps_toggle.text = "FPS: 30"
			else:
				$Menu/fps_toggle.text = "FPS: 60"
		elif menu == 2:
			$transition_2.visible = true;
			if FPS30:
				Engine.set_iterations_per_second(30);
			else:
				Engine.set_iterations_per_second(60);
			game_screen = true;
		elif menu == 3:
			$transition_2.visible = true;
			if FPS30:
				Engine.set_iterations_per_second(30);
			else:
				Engine.set_iterations_per_second(60);
			network_screen = true;
		
		#controles
		if input_controles[0][7] && comp_sg == 0:
			comp_sg = 1;
			match option:
				0: menu += 1;
				1: menu = 3;
				2: FPS30 = !FPS30;
		elif !input_controles[0][7]: comp_sg = 0;
		
		if menu == 1:
			if input_controles[0][3] && comp_up == 0:
				comp_up = 1;
				option -= 1;
			elif !input_controles[0][3]: comp_up = 0;
			if input_controles[0][2] && comp_dw == 0:
				comp_dw = 1;
				option += 1;
			elif !input_controles[0][2]: comp_dw = 0;
			
			if option < 0: option = 0;
			if option > 2: option = 2;
			
			if option == 0:
				$Menu/classic_mode.add_color_override("font_color", Color("ffffff"));
				$Menu/network_mode.add_color_override("font_color", Color("8c8c8c"));
				$Menu/fps_toggle.add_color_override("font_color", Color("8c8c8c"));
			elif option == 1:
				$Menu/classic_mode.add_color_override("font_color", Color("8c8c8c"));
				$Menu/network_mode.add_color_override("font_color", Color("ffffff"));
				$Menu/fps_toggle.add_color_override("font_color", Color("8c8c8c"));
			
			elif option == 2:
				$Menu/classic_mode.add_color_override("font_color", Color("8c8c8c"));
				$Menu/network_mode.add_color_override("font_color", Color("8c8c8c"));
				$Menu/fps_toggle.add_color_override("font_color", Color("ffffff"));
