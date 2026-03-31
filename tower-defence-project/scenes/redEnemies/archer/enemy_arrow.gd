extends CharacterBody2D

@onready var arrowSprite = $Sprite2D
var speed = 400
var atkdamage = 4
var direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	checkDir()
	velocity = direction * speed
	move_and_slide()

func checkDir():
	if direction.x >= 0.0:
		arrowSprite.flip_h = false
	else:
		arrowSprite.flip_h = true

	


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_unit"):
		body.take_damage(atkdamage)
		self.queue_free()
