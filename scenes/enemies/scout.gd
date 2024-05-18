extends CharacterBody2D

var player_nearby: bool = false
var can_laser: bool = true
var first_laser: bool = true

var health: int = 30
var vulnerable: bool = true

signal laser(pos, direction)

func _ready():
	$Sprite2D.material = $Sprite2D.material.duplicate()

func hit():
	if vulnerable:
		$Timers/HitTimer.start()
		vulnerable = false
		health -= 10
		$Sprite2D.material.set_shader_parameter("progress", 1)
		$HitSound.play()
	if health <= 0:
		queue_free()

func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var marker_node = $LaserSpawnPositions.get_child(first_laser)
			first_laser = not first_laser
			var pos: Vector2 = marker_node.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$Timers/LaserTimer.start()
			
func _on_attack_area_body_entered(_body):
	player_nearby = true


func _on_attack_area_body_exited(_body):
	player_nearby = false


func _on_laser_timer_timeout():
	can_laser = true


func _on_damage_cooldown_timeout():
	vulnerable = true
	$Sprite2D.material.set_shader_parameter("progress", 0)
