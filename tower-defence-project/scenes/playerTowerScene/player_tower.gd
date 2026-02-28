extends Node2D
@export var lancerUnit: PackedScene
@export var pawnUnit: PackedScene
@export var mageUnit: PackedScene
@export var archerUnit: PackedScene
@export var heavyUnit: PackedScene

@onready var spawn_point = $unit_spawn_point
@export var spawnPointH: float = 400
@export var spawnPointW: float = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func spawn_lancer():
	if lancerUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_lancer_unit = lancerUnit.instantiate()
	new_lancer_unit.global_position = spawn_point.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_lancer_unit)
func spawn_pawn():
	if pawnUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_pawn_unit = pawnUnit.instantiate()
	new_pawn_unit.global_position = spawn_point.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_pawn_unit)
func spawn_mage():
	if mageUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_mage_unit = mageUnit.instantiate()
	new_mage_unit.global_position = spawn_point.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_mage_unit)

func spawn_archer():
	if archerUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_archer_unit = archerUnit.instantiate()
	new_archer_unit.global_position = spawn_point.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_archer_unit)
	
func spawn_heavy():
	if heavyUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_heavy_unit = heavyUnit.instantiate()
	new_heavy_unit.global_position = spawn_point.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_heavy_unit)
