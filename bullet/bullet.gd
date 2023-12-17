extends Node2D

var speed = 40  # Adjust the bullet speed as needed
var direction = Vector2(0, -1)  # Initial direction (upward)


# Called when the node enters the scene tree for the first time.
func _ready():
	if direction.x < 0:
		$Sprite2D.flip_h = true
	if direction.y > 0:
		$Sprite2D.flip_v = true
	add_to_group("bullet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the bullet upwards (assuming top-down game)
	position += direction * speed * delta

	# Destroy the bullet when it goes off-screen
	#if not get_viewport_rect().has_point(position):
	#print("deleted")
	#queue_free()


func _on_body_entered(body):
	if body == G.player:
		G.player.apply_speed_debuff()
	queue_free()
