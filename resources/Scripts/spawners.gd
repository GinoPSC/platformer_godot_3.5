extends SceneTree;

var spawners = self.get_nodes_in_group("Spawner");
var S_PR = spawners[0];
var S_EN = spawners[1];
var S_IT = spawners[2];
var S_EF = spawners[3];

var S_CA = self.get_nodes_in_group("Camera")[0];
