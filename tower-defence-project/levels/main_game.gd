extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Game_HUD.lancer_spawn_requested.connect(on_lancer_spawn_requested)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_lancer_spawn_requested():
	$playerTower.spawn_lancer()
