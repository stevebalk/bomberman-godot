extends Node3D
var explosion_size := 10
var offset = 1
var grid_size := 2
var used_cells
@export var explosion : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = position.x - fmod(position.x, 2.0) + sign(position.x) * offset
	position.z = position.z - fmod(position.z, 2.0) + sign(position.z) * offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_explosion(direction: Vector3, length: int, offset: int) -> void:
	var new_position: Vector3
	var child: Node
	print(used_cells)
	for i in length:
		new_position = position + (direction * grid_size) * (i + offset)
		print("NEW POSITION = " + str(new_position))
		if new_position - Vector3(grid_size / 2, 0, grid_size / 2) in used_cells:
			break
		child = explosion.instantiate()
		child.position = new_position
		get_parent().add_child(child)

func spawn_explosions() -> void:
	spawn_explosion(Vector3.ZERO, 1, 0)
	spawn_explosion(Vector3.RIGHT, explosion_size, 1)
	spawn_explosion(Vector3.LEFT, explosion_size, 1)
	spawn_explosion(Vector3.FORWARD, explosion_size, 1)
	spawn_explosion(Vector3.BACK, explosion_size, 1)

func _on_animation_player_animation_finished(anim_name):
	spawn_explosions()
	queue_free()
