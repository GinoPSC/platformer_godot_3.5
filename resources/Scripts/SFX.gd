extends Sprite;
var FPS = Engine.get_iterations_per_second();

var effect = 0;
var x = 0;
func _ready():
	var y = sprite_config[effect][1]+1;
	var w = sprite_config[effect][2]-2;
	var h = sprite_config[effect][3]-2;
	x = w;
	
	self.region_rect.position = Vector2(11, y);
	self.region_rect.size = Vector2(w, h);

var current_sprite = 0;
var current_time = 0;
func _physics_process(_delta):
	if FPS == 30: current_time = 1;
	if current_time > 0:
		self.region_rect.position.x = 11+((x+12)*current_sprite);
		current_sprite += 1;
		current_time = 0;
	else: current_time += 1;
	
	if current_sprite > sprite_config[effect][0]:
		self.queue_free();

var sprite_config = [
	[27,10,50,110],		#0 grenade explotion
	[23,130,170,170],	#1 huge explotion
	[28,310,110,110],	#2 big explotion
	[10,430,110,110],	#3 cabom unknown
	[28,550,110,110],	#4 big grey explotion
	[28,670,110,110],	#5 big white explotion
	[29,790,110,170],	#6 big grenade explotion
	[28,970,50,50],		#7 explotion
	[28,1030,50,50],	#8 small explotion
	[10,1090,50,50],	#9 mine explotion
	[5,1150,50,50],		#10 hurt bullet explotion
	[8,1210,50,50],		#11 rebel grenade explotion
	[26,1270,50,110],	#12 firebomb explotion
	[28,1390,110,110],	#13 water big explotion
	[12,1510,110,110],	#14 air big firebomb explotion
	[12,1630,110,110],	#15 big firebomb explotion
	[15,1750,50,110],	#16 big firebomb explotion end
	[12,1870,50,50],	#17 soldier onfire
	[16,1930,50,50],	#18 blood shot
	[10,1990,50,50],	#19 blood knife
	[8,2050,110,110],	#20 blood shotgun
	[6,2170,50,50],		#21 get item
	[25,2230,50,110],	#22 water splash
	[6,2350,110,50],	#23 smoke splash
	[28,2410,50,50],	#24 white explotion
	[28,2470,50,50],	#25 small white explotion
	[28,2530,50,50],	#26 grey explotion
	[28,2590,50,50],	#27 small grey explotion
	[16,2650,50,50],	#28 blood shot z
	[10,2710,50,50],	#29 blood knife z
	[8,8770,110,110],	#30 blood shotgun z
	[16,2890,50,50],	#31 GO! Der
	[16,2950,50,50],	#32 GO! Izq
	[16,3010,50,50],	#33 GO! Arr
	[16,3070,50,50],	#34 GO! Aba
	[8,3130,110,50],	#35 OnWater
	[8,3190,110,50],	#36 OnWater Color 2
	[8,3250,110,50],	#37 OnWater Color 3
	[8,3310,110,50],	#38 OnWater Color 4
	[12,3370,50,50],	#39 Zombie Shot
	[19,3430,50,50],	#40 Zombie Shot Floor Clash
	[16,3490,50,50],	#41 Zombie Shot Clash
	[15,3550,110,110],	#42 Zombie Blow
	[13,3670,50,50],	#43 UFO Laser
	[21,3730,110,110],	#44 Bio explotion
	[23,3850,50,50],	#45 VFO Laser
	[23,3910,50,110],	#46 UFO Beam
	[25,4030,50,50]		#47 Bazooka Shoot
];
