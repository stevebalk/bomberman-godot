extends GridMap

var	used_cells
@export var wall : PackedScene

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var child: Node
	used_cells = get_used_cells()
	for cell in used_cells:
		child = wall.instantiate()
		child.position = cell * cell_size.x
		get_parent().add_child(child)
	queue_free()
