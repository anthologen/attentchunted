extends Node2D


func _physics_process(_delta):
	if G.player:
		$ProgressBar.value = G.player.speed / G.player.MAX_SPEED * 100
