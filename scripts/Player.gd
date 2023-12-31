extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
@export var explostion_size = 10
@export var bomb: PackedScene
var used_cells

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("bomb"):
		var child = bomb.instantiate()
		child.position = position
		child.explosion_size = explostion_size
		get_parent().add_child(child)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("bomb"):
		print("Found Bomb")
#		body.push(position.direction_to(body.position))
