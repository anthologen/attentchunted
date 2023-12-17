extends Node2D


func _physics_process(_delta):
	if G.player:
		$ProgressBar.value = G.player.health / 50.0 * 100
