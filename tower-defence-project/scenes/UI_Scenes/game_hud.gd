extends Control
signal lancer_spawn_requested
signal pawn_spawn_requested
var res_count_value = 0
var lancer_spawn_val = 6
var pawn_spawn_value = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PanelContainer/HSplitContainer/res_counter.text = str(res_count_value)


func _on_lancer_spawn_button_pressed() -> void:
	if res_count_value >= lancer_spawn_val:
		emit_signal("lancer_spawn_requested")
		res_count_value = res_count_value - lancer_spawn_val


func _on_pawn_unit_button_pressed() -> void:
	if res_count_value >= pawn_spawn_value:
		emit_signal("pawn_spawn_requested")
		res_count_value = res_count_value - pawn_spawn_value

func _on_res_count_timer_timeout() -> void:
	res_count_value += 1
