extends CharacterBody2D
var health = 8
var damage
var enemies_in_range = []
var attack_power = 4
var can_attack = true
var enemy_unit = null
var enemy_tower = null
var move_speed = 30
var direction = 1.0
@onready var reload_timer = $reloadTimer
@onready var current_state = state.RUN
@onready var anim = $AnimatedSprite2D
enum state{
	IDLE,
	RUN,
	SHOOT,
	HURT,
	DEATH,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)-> void:
	clean_enemy_list()
	print(enemies_in_range, " " , current_state)
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.RUN:
			handle_run(delta)
		state.SHOOT:
			handle_shoot(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
		
	move_and_slide()

func clean_enemy_list():
	for enemy in enemies_in_range:
		if !is_instance_valid(enemy):
			enemies_in_range.erase(enemy)

func get_closest_enemy():
	var closest = null
	var closest_dist = INF
	for enemy in enemies_in_range:
		if !is_instance_valid(enemy):
			continue
		var d = global_position.distance_to(enemy.global_position)
		if d < closest_dist:
			closest = enemy
			closest_dist = d
	return closest


func get_valid_enemy():
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			return enemy
		return null


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
	
func handle_shoot(delta):
	if enemy_unit == null or !is_instance_valid(enemy_unit):
		if enemies_in_range.size() > 0:
			enemy_unit = get_valid_enemy()
		else:
			current_state = state.RUN
			return
	enemy_unit = get_closest_enemy()
	velocity = Vector2.ZERO
	if can_attack:
		anim.play("shooting")
		reload_timer.start()
		enemy_unit.take_damage(attack_power)
		can_attack = false


func handle_hurt(delta):
	pass

func handle_death(delta):
	pass

func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_unit"):
		enemies_in_range.append(body)
		if enemy_unit == null:
			enemy_unit = body
			current_state = state.SHOOT

func _on_enemy_detection_body_exited(body: Node2D) -> void:
	#check if enemy
	if body.is_in_group("enemy_unit"):
		#subtract from enemy list
		enemies_in_range.erase(body)
		#check if enemy range list is greater than 0
		if body == enemy_unit:
			if enemies_in_range.size() > 0:
				enemy_unit = enemies_in_range[0]
			else:
				enemy_unit = null
				#if no enemies change state
				current_state= state.RUN


func _on_reload_timer_timeout() -> void:
	can_attack = true
