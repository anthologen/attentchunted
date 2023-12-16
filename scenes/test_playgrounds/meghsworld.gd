extends Node2D

const ENEMY_SCENE = preload("res://enemies/lurcher.tscn")


func _ready():
	var cells = $TileMap.get_used_cells(0)
	for c in cells:
		var coords = $TileMap.get_cell_atlas_coords(0, c)
		if coords == Vector2i(2, 14):
			G.graves.push_back(c)


func _process(_delta):
	while G.enemy_count < G.graves.size():
		var enemy = ENEMY_SCENE.instantiate()
		enemy.global_position = Vector2(16 * G.graves.pick_random()) + Vector2(16, 16)
		get_node("enemies").add_child(enemy)
