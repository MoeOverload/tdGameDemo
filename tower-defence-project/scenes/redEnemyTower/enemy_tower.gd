extends Node2D
var can_spawn = true
var round_active = true
var numSpawned = 0
var unit_scene = null
@export var lancerUnit: PackedScene
@export var pawnUnit: PackedScene
@export var mageUnit: PackedScene
@export var archerUnit: PackedScene
@export var heavyUnit: PackedScene
@export var spawnPointH: float = 400
@export var spawnPointW: float = 300
@onready var spawner = $enemySpawner
@onready var spawnTimer = $spawnTimer
@onready var roundCooldown = $roundCooldown
enum state{
	ROUND01,
	ROUND02,
	ROUND03,
	ROUND04,
	FINALROUND,
}
@onready var current_state = state.ROUND03
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(current_state,numSpawned)
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
	if !round_active:
		return
	if !can_spawn:
		return
	if numSpawned >= 7:
		round_active = false
		current_state = state.ROUND02
		roundCooldown.start()
		return

	# Spawn unit
	spawn_unit(pawnUnit)
	numSpawned += 1

	can_spawn = false
	spawnTimer.start()
	
func handle_ROUND2():
	if !round_active:
		return
	if !can_spawn:
		return
	
	if numSpawned >=8:
		round_active = false
		
		current_state = state.ROUND03
		roundCooldown.start()
		return
	if numSpawned <= 1:
		spawn_unit(archerUnit)	
	elif numSpawned >= 1 and numSpawned<= 5:
		spawn_unit(pawnUnit)
	else:
		spawn_unit(archerUnit)
	numSpawned += 1
	can_spawn = false
	spawnTimer.start()

func handle_ROUND3():
	if !round_active:
		return
	if !can_spawn:
		return
	if numSpawned >=12:
		round_active = false
		
		current_state = state.ROUND04
		roundCooldown.start()
		return
	if numSpawned <=4:
		spawn_unit(pawnUnit)
	elif numSpawned >=5 and numSpawned <=7:
		spawn_unit(archerUnit)
	elif numSpawned >=9 and numSpawned <=11:
		spawn_unit(lancerUnit)
	elif numSpawned >= 11 and numSpawned <=12:
		spawn_unit(pawnUnit)
	
	numSpawned +=1
	can_spawn = false
	spawnTimer.start()
func handle_ROUND4():
	pass
	
func handle_F_round():
	pass
	
func _on_spawn_timer_timeout() -> void:
	can_spawn = true
	

func spawn_unit(unit_scene):
	if unit_scene == null:
		return
	var random_x = randf_range(-spawnPointW/2, spawnPointW/2)
	var random_y = randf_range(-spawnPointH/2, spawnPointH/2)
	var new_unit = unit_scene.instantiate()
	new_unit.global_position = spawner.global_position + Vector2(random_x,random_y)
	get_tree().current_scene.add_child(new_unit)


func _on_round_cooldown_timeout() -> void:
	
	numSpawned = 0
	round_active = true
