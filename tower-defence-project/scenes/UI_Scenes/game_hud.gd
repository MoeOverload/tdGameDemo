extends Control
signal lancer_spawn_requested
signal pawn_spawn_requested
signal mage_spawn_requested
signal archer_spawn_requested
signal heavy_spawn_requested
var res_count_value = 0
var heavy_spawn_val = 10
var mage_spawn_value = 8
var lancer_spawn_val = 6
var archer_spawn_val = 4
var pawn_spawn_value = 2
var can_spawn = true
@onready var spawnCapTimer = $spawnCapTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PanelContainer/HBoxContainer/res_counter.text = str(res_count_value)


func _on_lancer_spawn_button_pressed() -> void:
	if !can_spawn:
		return
	if res_count_value >= lancer_spawn_val:
		can_spawn = false
		spawnCapTimer.start()
		emit_signal("lancer_spawn_requested")
		res_count_value = res_count_value - lancer_spawn_val


func _on_pawn_unit_button_pressed() -> void:
	if !can_spawn:
		return
	if res_count_value >= pawn_spawn_value:
		can_spawn = false
		spawnCapTimer.start()
		emit_signal("pawn_spawn_requested")
		res_count_value = res_count_value - pawn_spawn_value
		
func _on_mage_spawn_button_pressed() -> void:
	if !can_spawn:
		return
		
	if res_count_value >= mage_spawn_value:
		can_spawn = false
		spawnCapTimer.start()
		emit_signal("mage_spawn_requested")
		res_count_value = res_count_value - mage_spawn_value

func _on_archer_spawn_button_pressed() -> void:
	if !can_spawn:
		return
	if res_count_value >= archer_spawn_val:
		can_spawn = false
		spawnCapTimer.start()
		emit_signal("archer_spawn_requested")
		res_count_value = res_count_value - archer_spawn_val
	
	
func _on_heavy_spawn_button_pressed() -> void:
	if !can_spawn:
		return
	if res_count_value >= heavy_spawn_val:
		can_spawn = false
		spawnCapTimer.start()
		emit_signal("heavy_spawn_requested")
		res_count_value = res_count_value - heavy_spawn_val
	
		
func _on_res_count_timer_timeout() -> void:
	res_count_value += 1


func _on_spawn_cap_timer_timeout() -> void:
	can_spawn = true
	
