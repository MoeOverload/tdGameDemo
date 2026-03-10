extends Node2D
var can_spawn = true
var R1_numSpawned = 0
@export var lancerUnit: PackedScene
@export var pawnUnit: PackedScene
@export var mageUnit: PackedScene
@export var archerUnit: PackedScene
@export var heavyUnit: PackedScene
@export var spawnPointH: float = 400
@export var spawnPointW: float = 300
@onready var spawner = $enemySpawner
@onready var spawnTimer = $spawnTimer
enum state{
	ROUND01,
	ROUND02,
	ROUND03,
	ROUND04,
	FINALROUND,
}
@onready var current_state = state.ROUND01
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		state.ROUND01:
			handle_ROUND1()
		state.ROUND02:
			handle_ROUND2()
		state.ROUND03:
			handle_ROUND3()
		state.ROUND04:
			handle_ROUND4()
		state.FINALROUND:
			handle_F_round()

func handle_ROUND1():
	if can_spawn:
		spawn_pawn()
		spawnTimer.start()
		can_spawn = false
		R1_numSpawned += 1
	if R1_numSpawned == 5:
		current_state = state.ROUND02
	
func handle_ROUND2():
	pass
	
func handle_ROUND3():
	pass
	
func handle_ROUND4():
	pass
	
func handle_F_round():
	pass
	
func _on_spawn_timer_timeout() -> void:
	can_spawn = true

func spawn_pawn():
	if pawnUnit == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_pawn_unit = pawnUnit.instantiate()
	new_pawn_unit.global_position = spawner.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_pawn_unit)
