extends Node2D

var speed = 40  # Adjust the bullet speed as needed
var direction = Vector2(0, -1)  # Initial direction (upward)


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bullet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the bullet upwards (assuming top-down game)
	position += direction * speed * delta

	# Destroy the bullet when it goes off-screen
	if not get_viewport_rect().has_point(position):
		queue_free()
