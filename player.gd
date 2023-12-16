extends CharacterBody2D

const SPIKE_SCENE = preload("res://objects/spike.tscn")

const SPEED = 100.0
const EPSILON = 10
const DASH_DISTANCE = 48
const DASHING_FRAMES = 10

var angle = 0
var normal = Vector2(1, 0)
var dashing_frame = 0
var scything_frame = 0
var scything_positive = 1


func _ready():
	G.world = get_parent()
	G.spikes = get_parent().get_node("spikes")
	G.tilemap = get_parent().get_node("TileMap")
	G.camera = get_node("Camera2D")
	G.player = self


func _physics_process(_delta):
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if velocity.y or velocity.x:
		angle = velocity.angle()
		$Pointer.rotation = angle + PI / 2
	if velocity.x:
		scything_positive = 1 if velocity.x > 0 else -1
		$Scythe.scale.x = scything_positive
	if Input.is_action_just_pressed("dash") and not is_dashing():
		normal = Vector2(1, 0) if velocity.length() < EPSILON else velocity.normalized()
		dashing_frame = DASHING_FRAMES
	if Input.is_action_just_pressed("action"):
		var action_normal = Vector2(1, 0).rotated(angle)
		action_normal = normal if is_dashing() else action_normal
		fire_spike(action_normal)
	elif dashing_frame > 0:
		var col = move_and_collide(normal * DASH_DISTANCE / DASHING_FRAMES)
		if col:
			handle_collision(col.get_collider())
		dashing_frame -= 1
	else:
		move_and_slide()
		for c in range(0, get_slide_collision_count()):
			var col = get_slide_collision(c)
			handle_collision(col.get_collider())
	if scything_frame > 0:
		$Scythe.rotate(scything_positive * 10 * PI / 180)
		$Scythe.scale.x = scything_positive
		scything_frame -= 1
	else:
		$Scythe.rotation_degrees = -scything_positive * 15


func is_dashing():
	return dashing_frame != 0


func handle_collision(object):
	if object.is_in_group("enemy"):
		object.queue_free()


func fire_spike(dir):
	var spike = SPIKE_SCENE.instantiate()
	spike.setup(global_position, dir)
	scything_positive = -1 if dir.x < 0 else 1
	$Scythe.scale.x = scything_positive
	$Scythe.rotation_degrees = -scything_positive * 15
	scything_frame = 10
	G.spikes.add_child(spike)
