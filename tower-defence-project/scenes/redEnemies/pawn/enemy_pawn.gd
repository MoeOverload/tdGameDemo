extends CharacterBody2D
var health = 6
var player_units_in_range = []
var damage
var move_speed = 30
var direction = -1.0
var can_attack = true
var attack_power = 2
var attack_range = 55
var attack_Rbuffer = 10
var damage_label_time = 0.5
var damage_label_timer = 0.0
var player_unit = null
var player_tower = null
var coin_amount = 20
var newCoin = null

@onready var atck_cooldown = $attack_cooldown
@onready var current_state = state.RUN
@onready var anim = $AnimatedSprite2D
@onready var damage_label = $health_hud/damage_label
@export var coin : PackedScene
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
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)-> void:
	clean_unit_list()
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
	


func clean_unit_list():
	for unit in player_units_in_range:
		if !is_instance_valid(unit):
			player_units_in_range.erase(unit)

func coinDrop():
	newCoin = coin.instantiate()
	get_tree().current_scene.add_child(newCoin)
	newCoin.global_position = self.global_position
	newCoin.setValue(coin_amount)
	newCoin.fly_to(GameManager.c_target)
	

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
	#check if the enemy is valid
	if player_unit == null or !is_instance_valid(player_unit):
		#if the list of enemies is not none
		if player_units_in_range.size() > 0:
			#target the first enemy in the list
			player_unit = get_valid_unit()
		else:
			#else change state
			current_state = state.CHASE
			return
	#check distance from enemies
	player_unit = get_closest_unit()
	var distance = global_position.distance_to(player_unit.global_position)
	#change state if distance is greater than varaible + buffer
	if distance > attack_range + attack_Rbuffer:
		current_state = state.CHASE
		return
	#set velocity to zero
	velocity = Vector2.ZERO
	#check if the attack cooldown is done
	if can_attack:
		#play animation start cooldown and send signal to the targeted enemy, reset cooldown var
		anim.play("attack")
		atck_cooldown.start()
		player_unit.take_damage(attack_power)
		can_attack = false
	
func handle_chase(delta):
	#check if the enemy is valid
	if player_unit == null or !is_instance_valid(player_unit):
		#if the list of enemies is not none
		if player_units_in_range.size() > 0:
			#target the first enemy in the list
			player_unit = get_valid_unit()
		else:
			#change state
			current_state = state.RUN
			return
	#check distance to the enemy
	var distance = global_position.distance_to(player_unit.global_position)
	#check if enemy is in attack range
	if distance <= attack_range:
		#change state accordingly
		current_state= state.ATTACK
		return
	#set the chase direction
	var chase_direction =  (player_unit.global_position - global_position).normalized()
	#play animation and flip based on direction
	anim.play("run")
	if chase_direction.x >=0:
		anim.flip_h = false
	else:
		anim.flip_h = true
	#set velocity
	velocity = chase_direction * move_speed
	
	
func handle_hurt(delta):
	damage_label.text = str("-",damage)
	damage_label.visible = true
	damage_label_timer += delta
	if damage_label_timer >= damage_label_time:
		damage_label.visible = false
		damage_label_timer = 0.0
		if player_unit:
			
			current_state = state.CHASE
		else:
			current_state = state.RUN
	if health <= 0:
		current_state = state.DEATH

func handle_death(delta):
	coinDrop()
	
		
	self.queue_free()
	
func take_damage(amount:int):
	damage = amount
	health -= amount
	current_state = state.HURT
func get_valid_unit():
	for unit in player_units_in_range:
		if is_instance_valid(unit):
			return unit
	return null
		
#enemy distance checker
func get_closest_unit():
	var closest = null
	var closest_dist = INF
	for unit in player_units_in_range:
		if !is_instance_valid(unit):
			continue
		var d = global_position.distance_to(unit.global_position)
		if d < closest_dist:
			closest = unit
			closest_dist = d
	return closest
	

#attack cooldown reset
func _on_attack_cooldown_timeout() -> void:
	can_attack = true

#player detection
func _on_enemy_detection_body_entered(body: Node2D) -> void:
	#check if enemy
	if body.is_in_group("player_unit"):
		#add enemy to list
		player_units_in_range.append(body)
		#set state and declare the enemy
		if player_unit == null:
			player_unit = body
			current_state = state.CHASE

#player detection (leaving)
func _on_enemy_detection_body_exited(body: Node2D) -> void:
	#check if enemy
	if body.is_in_group("player_unit"):
		#subtract from enemy list
		player_units_in_range.erase(body)
		#check if enemy range list is greater than 0
		if body == player_unit:
			if player_units_in_range.size() > 0:
				player_unit = player_units_in_range[0]
			else:
				player_unit = null
				#if no enemies change state
				current_state= state.RUN
