extends CharacterBody2D

const MAX_SPEED = 150.0
const MIN_SPEED = 0.0

@export var starting_direction: Vector2 = Vector2(0, 1)
@export var speed = MAX_SPEED

@onready var animation_tree = $AnimationTree
@onready var sprite = $Sprite2D
@onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	G.player = self
	update_animation_parameters(starting_direction)
	animation_tree.set("parameters/Walk/blend_position", starting_direction)
	$Timer.start()


func _physics_process(_delta):
	if speed == 0:
		get_tree().paused = true
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_raw_strength("move_down") - Input.get_action_strength("move_up")
	)

	update_animation_parameters(input_direction)

	if input_direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	velocity = input_direction * speed

	move_and_slide()
	pick_new_state()


func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)


func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("idle")


func handle_collision(object):
	print("player collision called")
	if object.is_in_group("enemy"):
		object.queue_free()
	elif object.is_in_group("bullet"):
		apply_speed_debuff()
		object.queue_free()


func apply_speed_debuff():
	var speed_debuff = 10  # TODO: get from bullet type
	speed = max(speed - speed_debuff, MIN_SPEED)


func passive_speed_regen():
	var speed_regen_rate = 1  # TODO: alter via power-up?
	speed = min(speed + speed_regen_rate, MAX_SPEED)


func _on_timer_timeout():
	passive_speed_regen()
