extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.c_target = $coin_target/Marker2D.global_position
	$Game_HUD.lancer_spawn_requested.connect(on_lancer_spawn_requested)
	$Game_HUD.pawn_spawn_requested.connect(on_pawn_spawn_requested)
	$Game_HUD.mage_spawn_requested.connect(on_mage_spawn_requested)
	$Game_HUD.archer_spawn_requested.connect(on_archer_spawn_requested)
	$Game_HUD.heavy_spawn_requested.connect(on_heavy_spawn_requested)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_lancer_spawn_requested():
	$playerTower.spawn_lancer()
func on_pawn_spawn_requested():
	$playerTower.spawn_pawn()
func on_mage_spawn_requested():
	$playerTower.spawn_mage()
func on_archer_spawn_requested():
	$playerTower.spawn_archer()
func on_heavy_spawn_requested():
	$playerTower.spawn_heavy()
