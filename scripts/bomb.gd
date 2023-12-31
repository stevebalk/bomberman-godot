extends CharacterBody3D
var explosion_size := 1
@export var explosion : PackedScene
@export var roll_speed := 1000.0
@onready var walls = get_parent().indestructible_walls
@onready var raycastN := $RayCastN
@onready var raycastE := $RayCastE
@onready var raycastS := $RayCastS
@onready var raycastW := $RayCastW
var offset = 1
var grid_size := 2
var used_cells
var vel := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_place_on_grid()
	set_raycast_length()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = vel * delta
	move_and_slide()



func _place_on_grid() -> void:
	var diff_to_grid: Vector2
	var _sign: Vector3
	
	_sign.x = sign(position.x)
	_sign.z = sign(position.z)
	diff_to_grid.x = abs(fmod(position.x, 2.0))
	diff_to_grid.y = abs(fmod(position.z, 2.0))
	if (diff_to_grid.x <= 1.0):
		position.x = position.x - diff_to_grid.x * _sign.x
	else:
		position.x = (position.x - diff_to_grid.x * _sign.x) + (grid_size * _sign.x)
	if (diff_to_grid.y <= 1.0):
		position.z = position.z - diff_to_grid.y * _sign.z
	else:
		position.z = (position.z - diff_to_grid.y * _sign.z) + (grid_size * _sign.z)
	position.y = 0

func set_raycast_length() -> void:
	raycastN.target_position.z = explosion_size * grid_size
	raycastE.target_position.x = explosion_size * grid_size
	raycastS.target_position.z = -explosion_size * grid_size
	raycastW.target_position.x = -explosion_size * grid_size

#func spawn_explosion(direction: Vector3, length: int, offset: int) -> void:
#	var new_position: Vector3i
#	var child: Node
#	used_cells = get_parent()
#	for i in length:
#		new_position = position + (direction * grid_size) * (i + offset)
#		used_cells = get_parent().get_used_cells()
#		if new_position / grid_size in used_cells:
#			print(walls.get_mesh_library().get_item_name(walls.get_cell_item(new_position / grid_size)))
#			walls.set_cell_item(new_position / grid_size, -1)
#			break
#		child = explosion.instantiate()
#		child.position = new_position
#		get_parent().add_child(child)

func spawn_explosion(_raycast: RayCast3D) -> void:
	if _raycast == null:
		return
	var collider = _raycast.get_collider()
	if collider and collider.is_in_group("destructible"):
		print("BOOM")
		collider.get_owner().queue_free()


#func spawn_explosions() -> void:
##	print(used_cells)
#	spawn_explosion(Vector3.ZERO, 1, 0)
#	spawn_explosion(Vector3.RIGHT, explosion_size, 1)
#	spawn_explosion(Vector3.LEFT, explosion_size, 1)
#	spawn_explosion(Vector3.FORWARD, explosion_size, 1)
#	spawn_explosion(Vector3.BACK, explosion_size, 1)
	
func spawn_explosions() -> void:
#	print(used_cells)
	spawn_explosion(null)
	spawn_explosion(raycastN)
	spawn_explosion(raycastE)
	spawn_explosion(raycastS)
	spawn_explosion(raycastW)

func _on_animation_player_animation_finished(anim_name):
	spawn_explosions()
	queue_free()

func push(direction: Vector3) -> void:
	print("Push triggered")
	vel = direction * roll_speed
