extends CharacterBody2D

#variables
var health = 10
var damage
var enemies_in_range = []
var move_speed = 30
var attack_power = 5
var attack_range = 55
var attack_rBuffer = 10
var direction = 1.0
var can_attack = true
var enemy_unit = null
var enemy_tower = null
var damage_label_timer = 0.0
var damage_label_time = 0.5
@onready var atck_cooldown = $attack_cooldown
@onready var current_state = state.RUN
@onready var anim = $AnimatedSprite2D
@onready var health_hud = $player_HUD/health_label


#states
enum state{
	IDLE,
	RUN,
	CHASE,
	ATTACK,
	HURT,
	DEATH,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)-> void:
	clean_enemy_list()
	#match the states/ statemachine
	match current_state:
		state.IDLE:
			handle_idle(delta)
		state.RUN:
			handle_run(delta)
		state.CHASE:
			handle_chase(delta)
		state.ATTACK:
			handle_attack(delta)
		state.HURT:
			handle_hurt(delta)
		state.DEATH:
			handle_death(delta)
		
	move_and_slide()
	

func clean_enemy_list():
	for enemy in enemies_in_range:
		if !is_instance_valid(enemy):
			enemies_in_range.erase(enemy)
#idle state logic
func handle_idle(_delta):
	#set velocity to zero
	velocity = Vector2.ZERO
	#play animation
	anim.play("idle")
	
	
#running state logic
func handle_run(_delta):
	#play animation
	anim.play("run")
	#flip direction of anim facing
	if direction >=0:
		anim.flip_h = false
	else:
		anim.flip_h = true
	#set velocity x-axis 
	velocity.x = direction * move_speed
	
	
#attack state logic
func handle_attack(delta):
	#check if the enemy is valid
	if enemy_unit == null or !is_instance_valid(enemy_unit):
		#if the list of enemies is not none
		if enemies_in_range.size() > 0:
			#target the first enemy in the list
			enemy_unit = get_valid_enemy()
		else:
			#else change state
			current_state = state.CHASE
			return
	#check distance from enemies
	enemy_unit = get_closest_enemy()
	var distance = global_position.distance_to(enemy_unit.global_position)
	#change state if distance is greater than varaible + buffer
	if distance > attack_range + attack_rBuffer:
		current_state = state.CHASE
		return
	#set velocity to zero
	velocity = Vector2.ZERO
	#check if the attack cooldown is done
	if can_attack:
		#play animation start cooldown and send signal to the targeted enemy, reset cooldown var
		anim.play("attack")
		atck_cooldown.start()
		enemy_unit.take_damage(attack_power)
		can_attack = false
		
		
#chase state logic
func handle_chase(delta):
	var chase_speed = 40
	#check if the enemy is valid
	if enemy_unit == null or !is_instance_valid(enemy_unit):
		#if the list of enemies is not none
		if enemies_in_range.size() > 0:
			#target the first enemy in the list
			enemy_unit = get_valid_enemy()
		else:
			#change state
			current_state = state.RUN
			return
	#check distance to the enemy
	var distance = global_position.distance_to(enemy_unit.global_position)
	#check if enemy is in attack range
	if distance <= attack_range:
		#change state accordingly
		current_state= state.ATTACK
		return
	#set the chase direction
	var chase_direction =  (enemy_unit.global_position - global_position).normalized()
	#play animation and flip based on direction
	anim.play("run")
	if chase_direction.x >=0:
		anim.flip_h = false
	else:
		anim.flip_h = true
	#set velocity
	velocity = chase_direction * chase_speed
	
#taking damgage function
func take_damage(amount:int):
	damage = amount
	health -= amount
	current_state = state.HURT
#hurt state logic
func handle_hurt(delta):
	health_hud.text = str("-",damage)
	health_hud.visible = true
	damage_label_timer += delta
	if damage_label_timer >= damage_label_time:
		health_hud.visible = false
		damage_label_timer = 0.0
		if enemy_unit:
			
			current_state = state.CHASE
		else:
			current_state = state.RUN
	if health <= 0:
		current_state = state.DEATH

#enemy validator
func get_valid_enemy():
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			return enemy
		return null
			
func handle_death(delta):
	self.queue_free()
	
#enemy distance checker
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
	
	
#attack cooldown reset timer
func _on_attack_cooldown_timeout() -> void:
	can_attack = true
#enemy detection logic
func _on_enemy_detection_body_entered(body: Node2D) -> void:
	#check if enemy
	if body.is_in_group("enemy_unit"):
		#add enemy to list
		enemies_in_range.append(body)
		#set state and declare the enemy
		if enemy_unit == null:
			enemy_unit = body
			current_state = state.CHASE
#enemy detection logic
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
