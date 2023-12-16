extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func setup(pos, dir):
	velocity = dir * SPEED
	if velocity.x < 0:
		$Sprite2D.scale.x = -1
	global_position = pos + dir * 16


func _physics_process(delta):
	var coll = move_and_collide(velocity * delta)
	if coll:
		if coll.get_collider().is_in_group("enemy"):
			coll.get_collider().queue_free()
		elif coll.get_collider() == G.tilemap:
			queue_free()
