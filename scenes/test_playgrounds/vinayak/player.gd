extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var sprite = $Sprite2D
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	G.player = self
	update_animation_parameters(starting_direction)
	animation_tree.set("parameters/Walk/blend_position", starting_direction)

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_raw_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	update_animation_parameters(input_direction)
	
	if (input_direction.x < 0):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("idle")
