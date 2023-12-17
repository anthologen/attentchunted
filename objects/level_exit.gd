extends Node2D


func _on_area_2d_body_entered(body):
	if body == G.player:
		G.current_level += 1
		var params = {
			"show_progress_bar": true,
		}
		Game.change_scene_to_file(G.levels[G.current_level], params)
