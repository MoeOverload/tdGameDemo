extends CharacterBody2D
var move_speed = 30
var direction = 1.0
enum state{
	IDLE,
	RUN,
	HEAL,
}
@onready var current_state = state.RUN
@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)-> void:
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.RUN:
			handle_run(delta)
		state.HEAL:
			handle_heal(delta)
		
	move_and_slide()
		


func handle_idle(_delta):
	velocity = Vector2.ZERO
	anim.play("idle")
	
func handle_run(_delta):
	anim.play("run")
	if direction >=0:
		anim.flip_h = false
	else:
		anim.flip_h = true
	velocity.x = direction * move_speed
	
func handle_heal(delta):
	pass
