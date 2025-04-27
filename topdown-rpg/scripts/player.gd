extends CharacterBody2D

const speed: float = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer


var current_dir = "none"
var enemy_attack_in_range: bool = false
var enemy_attack_cooldown: bool = true
var health: float = 100
var alive: bool = true

func _ready() -> void:
	animated_sprite.play("front_idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()

	
func player_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

func play_anim(movement) -> void:
	var dir = current_dir
	var anim = animated_sprite
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	elif dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
	elif dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("entered")
	enemy_attack_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	print("exited")
	enemy_attack_in_range = false
	
func enemy_attack() -> void:
	if enemy_attack_in_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		attack_cooldown_timer.start()
		print("Health: " + str(health))
		
func _on_attack_cooldown_timer_timeout() -> void:
	enemy_attack_cooldown = true
