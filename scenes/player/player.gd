extends CharacterBody2D

signal laser(pos, direction)
signal grenade(pos, direction)

var can_laser: bool = true 
var can_grenade: bool = true 

@export var max_speed: int = 500 
var speed: int = max_speed


func hit():
	Globals.health -= 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
 
	# input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_pos = global_position
	
	# rotate player
	look_at(get_global_mouse_position())
	
	var player_direction = (get_global_mouse_position() - position).normalized()

	# laser shooting input
	if Input.is_action_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$GPUParticles2D.emitting = true
		# randomly select a marker2D for the laser start
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		laser.emit(selected_laser.global_position, player_direction)
		$LaserTimer.start()
		
	if Input.is_action_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_grenade = false
		grenade.emit(selected_laser.global_position, player_direction)
		$GrenadeTimer.start()


func _on_laser_timer_timeout():
	can_laser = true

func _on_grenade_timer_timeout():
	can_grenade = true

