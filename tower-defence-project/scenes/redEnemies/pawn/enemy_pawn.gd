extends CharacterBody2D
var move_speed = 30
var direction = -1.0
var can_attack = true
@onready var hit_area = $attack_box/CollisionShape2D
@onready var atck_cooldown = $attack_cooldown
enum state{
	IDLE,
	RUN,
	ATTACK,
	DEFEND,
	HURT,
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
		state.ATTACK:
			handle_attack(delta)
		state.HURT:
			handle_hurt(delta)
		
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
	
func handle_attack(delta):
	if !can_attack:
		return
	velocity = Vector2.ZERO
	hit_area.disable_mode = false
	anim.play("attack")
	hit_area.disable_mode = true
	
	can_attack = false
	atck_cooldown.start()
	
	
func handle_hurt(delta):
	pass
func _on_enemy_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemyTower"):
		current_state = state.ATTACK


func _on_attack_cooldown_timeout() -> void:
	can_attack = true
