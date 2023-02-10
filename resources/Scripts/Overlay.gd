extends Panel

var IDJ = 0;
var right_side = false;
var down_side = false;
var target = null;
func _ready():
	var lf = str(IDJ+1)+"UP=2";
	$INFO/lifes.text = lf;
	$INFO/l_shadow.text = lf;
	$START.visible = false;
	
	if down_side: self.rect_position.y = 184;
	if right_side:
		self.rect_position.x = 150;
		
		#global
		var sd = 1;
		$AMMO.rect_position.x = 14+sd;
		$s_ammo.rect_position.x = 15+sd;
		$INFO.rect_position.x = 83+sd;
		$s_info.rect_position.x = 84+sd;
		
		#info
		$INFO/score.align = Label.ALIGN_LEFT;
		$INFO/s_shadow.align = Label.ALIGN_LEFT;
		$INFO/score.rect_position.x = -6;
		$INFO/s_shadow.rect_position.x = -5;
		$INFO/lifes.rect_position.x = 12;
		$INFO/l_shadow.rect_position.x = 13;
		
		#start
		$START/Press_Start.rect_position.x = 30;
		$START/PS_Shadow.rect_position.x = 31;
		
		#visible
		$s_ammo.visible = false;
		$s_info.visible = false;
		$AMMO.visible = false;
		$INFO.visible = false;

var player_bombs = -1;
var player_score = -1;
var start_time = 0;
var step = 0;
func _physics_process(_delta):
	target = self.get_tree().get_nodes_in_group("Character")[IDJ];
	
	if target.disabled:
		$s_ammo.visible = false;
		$s_info.visible = false;
		$AMMO.visible = false;
		$INFO.visible = false;
		if start_time > 100:
			if step == 0:
				$START.visible = true;
				start_time = 0;
				step = 1;
			else:
				$START.visible = false;
				start_time = 60;
				step = 0;
		else: start_time += 1;
	else:
		$s_ammo.visible = true;
		$s_info.visible = true;
		$AMMO.visible = true;
		$INFO.visible = true;
		$START.visible = false;
	
	$AMMO/bombsL.visible = false;
	if player_bombs != target.bomb_ammo:
		player_bombs = target.bomb_ammo;
		$AMMO/bombs.text = String(player_bombs);
		$s_ammo/bombs.text = $AMMO/bombs.text;
		$AMMO/bombsL.text = $AMMO/bombs.text;
		$AMMO/bombsL.visible = true;
	if player_score != target.score:
		player_score = target.score;
		$INFO/score.text = String(player_score);
		$INFO/s_shadow.text = $INFO/score.text;
