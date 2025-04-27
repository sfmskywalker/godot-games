extends CharacterBody2D
@onready var detection_area: Area2D = $DetectionArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 40
var player_chase: bool = false
var player: Node2D = null

func _on_ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed
		animated_sprite.play("side_walk")
		
		if position.x < player.position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("front_idle")
		
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
