extends Node2D

@export var lancerUnit: PackedScene
@export var pawnUnit: PackedScene
@export var mageUnit: PackedScene
@export var archerUnit: PackedScene
@export var heavyUnit: PackedScene
@export var spawnPointH: float = 400
@export var spawnPointW: float = 300
@onready var spawner = $enemySpawner
@onready var spawnTimer = $spawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	pass # Replace with function body.
func roundOne():
	pass
func spawn_pawn():
	if pawnUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_pawn_unit = pawnUnit.instantiate()
	new_pawn_unit.global_position = spawner.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_pawn_unit)
