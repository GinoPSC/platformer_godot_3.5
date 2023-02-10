extends Node2D

onready var connection_panel = $CanvasLayer/ConnectionPanel;
onready var host_field = $CanvasLayer/ConnectionPanel/GridContainer/HostField;
onready var port_field = $CanvasLayer/ConnectionPanel/GridContainer/PortField;
onready var message_label = $CanvasLayer/MessageLabel;
onready var sync_lost_label = $CanvasLayer/SyncLostLabel;

const folder_name = "logs/";
const LOG_FOLDER_PATH = "res://"+folder_name;
var exe_path = OS.get_executable_path().get_base_dir().plus_file(folder_name);

var logging_enabled := true;

func _ready():
	var result = null;
	result = self.get_tree().connect("network_peer_connected", self, "_on_network_peer_connected");
	if result: print(result);
	result = self.get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected");
	if result: print(result);
	result = self.get_tree().connect("server_disconnected", self, "_on_server_disconnected");
	if result: print(result);
	result = SyncManager.connect("sync_started", self, "_on_SyncManager_sync_started");
	if result: print(result);
	result = SyncManager.connect("sync_stopped", self, "_on_SyncManager_sync_stopped");
	if result: print(result);
	result = SyncManager.connect("sync_lost", self, "_on_SyncManager_sync_lost");
	if result: print(result);
	result = SyncManager.connect("sync_regained", self, "_on_SyncManager_sync_regained");
	if result: print(result);
	result = SyncManager.connect("sync_error", self, "_on_SyncManager_sync_error");
	if result: print(result);

func _on_ServerButton_pressed():
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(int(port_field.text), 1);
	self.get_tree().network_peer = peer;
	connection_panel.visible = false;
	message_label.text = "Listening...";

func _on_ClientButton_pressed():
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(host_field.text, int(port_field.text));
	self.get_tree().network_peer = peer;
	connection_panel.visible = false;
	message_label.text = "Connecting...";

func _on_network_peer_connected(peer_id: int):
	message_label.text = "Connected!";
	SyncManager.add_peer(peer_id);
	
	start_controllers();
	var net_group = self.get_tree().get_nodes_in_group("network_sync");
	var Control_0 = null;
	var Control_1 = null;
	for element in net_group:
		if "Control_0" in element.name:
			Control_0 = element;
		if "Control_1" in element.name:
			Control_1 = element;
	Control_0.set_network_master(1);
	if self.get_tree().is_network_server():
		Control_1.set_network_master(peer_id);
	else:
		Control_1.set_network_master(self.get_tree().get_network_unique_id());
	
	if self.get_tree().is_network_server():
		message_label.text = "Starting...";
		yield(self.get_tree().create_timer(2.0), "timeout");
		SyncManager.start();

func _on_network_peer_disconnected(peer_id: int):
	message_label.text = "Disconnected";
	SyncManager.remove_peer(peer_id);

func _on_server_disconnected():
	_on_network_peer_disconnected(1);

func _on_LeaveButton_pressed():
	SyncManager.stop();
	SyncManager.clear_peers();
	var peer = self.get_tree().network_peer;
	if peer:
		peer.close_connection();
	var error = self.get_tree().reload_current_scene();
	if error:
		print(error);

func _on_SyncManager_sync_started():
	message_label.text = "Started!";
	call_ready();
	#if logging_enabled && !SyncReplay.active:
	if logging_enabled:
		var dir = Directory.new();
		if !dir.dir_exists(LOG_FOLDER_PATH):
			dir.make_dir(LOG_FOLDER_PATH);
		
		#exe log
		dir = Directory.new();
		if !dir.dir_exists(exe_path):
			dir.make_dir(exe_path);
		
		var datetime = OS.get_datetime(true);
		var log_file_name = "%04d%02d%02d-%02d%02d%02d-peer-%d.log" % [
			datetime["year"],
			datetime["month"],
			datetime["day"],
			datetime["hour"],
			datetime["minute"],
			datetime["second"],
			self.get_tree().get_network_unique_id()
		]
		
		SyncManager.start_logging(LOG_FOLDER_PATH + '/' + log_file_name);
		SyncManager.start_logging(exe_path + '/' + log_file_name);

func _on_SyncManager_sync_stopped():
	message_label.text = "Stopped";
	
	if logging_enabled:
		SyncManager.stop_logging();
		SyncManager.stop_logging();

func _on_SyncManager_sync_lost():
	sync_lost_label.visible = true;

func _on_SyncManager_sync_regained():
	sync_lost_label.visible = false;
	
func _on_SyncManager_sync_error(msg: String):
	message_label.text = "Fatal sync error: " + msg;
	sync_lost_label.visible = false;
	print(msg);
	
	var peer = self.get_tree().network_peer;
	if peer:
		peer.close_connection();
	SyncManager.clear_peers();























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

var input_controles = [];
func start_controllers():
	for x in cantidad_jugadores:
		var player_controles = controles_ruta.instance();
		player_controles.set_position(Vector2(0,0));
		player_controles.default_controllers = true;
		player_controles.network_controllers = true;
		player_controles.IDJ = x;
		add_child(player_controles);
		player_controles.add_to_group("network_sync");
		input_controles.append(player_controles.net_controles);

func call_ready():
	var menu = menu_ruta.instance();
	menu.controles = input_controles;
	menu.cantidad_jugadores = cantidad_jugadores;
	menu.network_mode = true;
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
	my_random_number = 0;
	for x in cantidad_jugadores:
		var personaje = personaje_ruta.instance();
		personaje.set_position(Vector2( 0+25+(25*x), 0 ));
		personaje.IDJ = x;
		personaje.IDM = my_random_number;
		personaje.network_jump = true;
		my_random_number += 1;
		if my_random_number > 9: my_random_number = 0;
		personaje.controles = input_controles[x];
		add_child(personaje);
		personaje.add_to_group("Character");
		personaje.add_to_group("network_sync");
	
	var effects = effects_ruta.instance();
	effects.set_position(Vector2(0,0));
	add_child(effects);
	effects.add_to_group("Spawner");
	
	var nivelF = nivelF_ruta.instance();
	nivelF.set_position(Vector2(0,0));
	add_child(nivelF);
	nivel.animationsF = nivelF.get_children();
