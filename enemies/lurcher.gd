extends CharacterBody2D

const SPEED = 30.0
const EPSILON = 10
const DASH_IF = 40
const DASH_DISTANCE = 48
const DASHING_FRAMES = 30
var angle = 0
var normal = Vector2(1, 0)
var dashing_frame = 0


func _ready():
	add_to_group("enemy")
	add_to_group("enemy/lurcher")
	G.enemy_count += 1


func _exit_tree():
	G.enemy_count -= 1


func _physics_process(_delta):
	if not G.player:
		return
	normal = global_position.direction_to(G.player.global_position)
	velocity = SPEED * normal
	if (G.player.global_position - position).length() < DASH_IF:
		normal = Vector2(1, 0) if velocity.length() < EPSILON else velocity.normalized()
		dashing_frame = DASHING_FRAMES
	if dashing_frame > 0:
		var col = move_and_collide(normal * DASH_DISTANCE / DASHING_FRAMES)
		if col and col.get_collider() == G.player:
			G.player.handle_collision(self)
		dashing_frame -= 1
	else:
		move_and_slide()
	handle_collisions()


func is_dashing():
	return dashing_frame != 0


func handle_collisions():
	for c in range(0, get_slide_collision_count()):
		var col = get_slide_collision(c)
		if col.get_collider() == G.player:
			G.player.handle_collision(self)
