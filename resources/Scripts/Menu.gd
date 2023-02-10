extends CanvasLayer;
var main_menu_rute = "res://resources/Objects/Main_Menu.tscn";
var overlay_rute = load("res://resources/Objects/Overlay.tscn");
var cantidad_jugadores = 4;
var network_mode = false;
var group_overlay = [];
func _ready():
	for x in cantidad_jugadores:
		var overlay = overlay_rute.instance();
		overlay.IDJ = x;
		if x == 1 || x == 3: overlay.right_side = true;
		if x == 2 || x == 3: overlay.down_side = true;
		group_overlay.append(overlay);
		self.add_child(group_overlay[x]);
	$Pause.visible = false;

var controles = [];
var CompP = [0,0,0,0];
var CompB = [0,0,0,0];
var pause_owner = 0;
func _physics_process(_delta):
	var targets = self.get_tree().get_nodes_in_group("Character");
	for x in 4:
		if !targets[x].disabled:
			if controles[x][7] && CompP[x] == 0:
				CompP[x] = 1;
				if !network_mode:
					self.get_tree().paused = !self.get_tree().paused;
				$Pause.visible = !$Pause.visible;
				if $Pause.visible: pause_owner = x;
				for y in 4:
					group_overlay[y].visible = !group_overlay[y].visible;
			elif !controles[x][7]: CompP[x] = 0;
			if $Pause.visible && controles[pause_owner][4] && CompB[pause_owner] == 0:
				CompB[pause_owner] = 1;
				if self.get_tree().change_scene(main_menu_rute):
					print ("Scene main menu time out");
				self.get_tree().paused = false;
				self.get_parent().queue_free();
			elif !controles[pause_owner][4]: CompB[pause_owner] = 0;
		elif targets[x].disabled && !$Pause.visible:
			if controles[x][7] && CompP[x] == 0:
				CompP[x] = 1;
				targets[x].disabled = false;
			elif !controles[x][7]: CompP[x] = 0;
