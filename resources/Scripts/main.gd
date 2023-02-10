extends ViewportContainer;

var controles_ruta = load("res://resources/Objects/Controles.tscn");
var menu_ruta = load("res://resources/Objects/Menu.tscn");
#var nivel_ruta = load("res://resources/Objects/Nivel.tscn");
var nivel_ruta = load("res://resources/Objects/Stage1_1.tscn");
var nivelF_ruta = load("res://resources/Objects/Stage1_1F.tscn");
var nivelB_ruta = load("res://resources/Objects/Stage1_1B.tscn");
var camara_ruta = load("res://resources/Objects/Camara.tscn");
var personaje_ruta = load("res://resources/Objects/Personaje.tscn");
var proyectiles_ruta = load("res://resources/Objects/Projectiles.tscn");
var enemies_ruta = load("res://resources/Objects/Enemies.tscn");
var items_ruta = load("res://resources/Objects/Items.tscn");
var effects_ruta = load("res://resources/Objects/Effects.tscn");
var enemy_attacks_ruta = load("res://resources/Objects/Enemy_Attacks.tscn");
var cantidad_jugadores = 4;

func _ready():
	var input_controles = [];
	for x in cantidad_jugadores:
		var player_controles = controles_ruta.instance();
		player_controles.set_position(Vector2(0,0));
		player_controles.default_controllers = true;
		player_controles.IDJ = x;
		add_child(player_controles);
		input_controles.append(player_controles.controles);
	
	var menu = menu_ruta.instance();
	menu.controles = input_controles;
	menu.cantidad_jugadores = cantidad_jugadores;
	add_child(menu);
	
	var nivelB = nivelB_ruta.instance();
	#nivelB.transform = Transform2D(0,Vector2(0,-112));
	add_child(nivelB);
	
	var camara = camara_ruta.instance();
	camara.set_position(Vector2(0,0));
	add_child(camara);
	camara.add_to_group("Camera");
	
	var nivel = nivel_ruta.instance();
	nivel.set_position(Vector2(0,0));
	add_child(nivel);
	
	var proyectiles = proyectiles_ruta.instance();
	proyectiles.set_position(Vector2(0,0));
	add_child(proyectiles);
	proyectiles.add_to_group("Spawner");
	
	var enemy_attacks = enemy_attacks_ruta.instance();
	enemy_attacks.set_position(Vector2(0,0));
	add_child(enemy_attacks);
	enemy_attacks.add_to_group("Spawner");
	
	var enemies = enemies_ruta.instance();
	enemies.set_position(Vector2(0,0));
	add_child(enemies);
	enemies.add_to_group("Spawner");
	
	var items = items_ruta.instance();
	items.set_position(Vector2(0,0));
	add_child(items);
	items.add_to_group("Spawner");
	
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	var my_random_number = rng.randf_range(0, 9);
	#my_random_number = 0;
	for x in cantidad_jugadores:
		var personaje = personaje_ruta.instance();
		personaje.set_position(Vector2( 0+25+(25*x), 0 ));
		personaje.IDJ = x;
		personaje.IDM = my_random_number;
		my_random_number += 1;
		if my_random_number > 9: my_random_number = 0;
		personaje.controles = input_controles[x];
		add_child(personaje);
		personaje.add_to_group("Character");
	
	var effects = effects_ruta.instance();
	effects.set_position(Vector2(0,0));
	add_child(effects);
	effects.add_to_group("Spawner");
	
	var nivelF = nivelF_ruta.instance();
	nivelF.set_position(Vector2(0,0));
	add_child(nivelF);
	nivel.animationsF = nivelF.get_children();
