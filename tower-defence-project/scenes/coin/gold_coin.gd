extends Node2D
var target_position : Vector2
var speed = 600
var is_moving = false
var can_move = false
var coin_value
@onready var timer = $move_wait_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !is_moving:
		return
	if !can_move:
		return
	
	var direction = (target_position - global_position).normalized()
	global_position += direction * speed *delta

	if global_position.distance_to(target_position) < 5:
		collect()
	


func setValue(value:int):
	coin_value = value
	timer.start()

func fly_to(target:Vector2):
	target_position = target
	is_moving = true

func collect():
	GameManager.add_coins(coin_value)
	can_move = false
	queue_free()


func _on_move_wait_time_timeout() -> void:
	can_move = true
