extends Node3D

@onready var blocked_cells = get_node("IndestructableObjects").get_used_cells()
@onready var indestructible_walls = get_node("IndestructableObjects")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_used_cells() -> Array:
	return (get_node("IndestructableObjects").get_used_cells())
