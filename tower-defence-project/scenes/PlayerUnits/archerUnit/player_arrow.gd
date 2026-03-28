extends CharacterBody2D


var speed = 400
var atkdamage = 4
var direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()


func _on_enemy_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_unit"):
		body.take_damage(atkdamage)
		self.queue_free()
