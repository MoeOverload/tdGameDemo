extends Control
signal lancer_spawn_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lancer_spawn_button_pressed() -> void:
	emit_signal("lancer_spawn_requested")
