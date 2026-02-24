extends Node2D
@export var lancerUnit: PackedScene
@export var pawnUnit: PackedScene
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
	var new_lancer_unit = lancerUnit.instantiate()
	new_lancer_unit.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_lancer_unit)
func spawn_pawn():
	if pawnUnit == null:
		return
	var new_pawn_unit = pawnUnit.instantiate()
	new_pawn_unit.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(new_pawn_unit)
