extends CharacterBody2D

var moving: bool = false
var player_near: bool = false
var speed: int = 300
var can_attack: bool = true
var vulnerable: bool = true
var health: int = 30

func _ready():
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()

func hit():
	if vulnerable:
		$Timers/HitTimer.start()
		vulnerable = false
		health -= 10
		$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
		$Particles/HitParticles.emitting = true
		$AudioStreamPlayer2D.play()
	if health <= 0:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _process(_delta):
	if moving:
		var direction = (Globals.player_pos - global_position).normalized()
		velocity = speed * direction
		move_and_slide()
		look_at(Globals.player_pos)	


func _on_notice_area_2d_body_entered(_body):
	moving = true
	$AnimatedSprite2D.play("Walk")	


func _on_notice_area_2d_body_exited(_body):
	moving = false
	$AnimatedSprite2D.stop()
	
	


func _on_attack_area_2d_body_entered(_body):
	player_near = true
	print(_body.name)
	moving = false
	$AnimatedSprite2D.play("Attack")
	


func _on_attack_area_2d_body_exited(_body):
	player_near = false
	moving = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("Walk")

func _on_hit_timer_timeout():
	vulnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)


func _on_attack_timer_timeout():
	can_attack = true
	$AnimatedSprite2D.play("Attack")


func _on_animated_sprite_2d_animation_finished():
	if player_near:
		print("attacking")
		print(name)
		Globals.health -= 10
		$Timers/AttackTimer.start()
		
