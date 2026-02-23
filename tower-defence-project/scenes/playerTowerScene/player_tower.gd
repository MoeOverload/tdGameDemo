extends Node2D
@export var lancerUnit: PackedScene
@onready var spawn_point = $unit_spawn_point
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func spawn_lancer():
	if lancerUnit == null:
		return
	var new_unit = lancerUnit.instantiate()
	new_unit.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_unit)
