extends Area2D
	
var rotation_speed: int = 4
var available_options = ['laser', 'laser', 'laser', 'laser', 'grenade', 'health']
var type = available_options.pick_random()

var direction: Vector2
var distance: int = randi_range(150, 250)

func _ready():
	if type == 'laser':
		$Sprite2D.modulate = Color(0.1, 0.2, 0.6)
	elif type == 'grenade':
		$Sprite2D.modulate = Color(0.8, 0.2, 0.1)
	elif type == 'health':
		$Sprite2D.modulate = Color(0.1, 0.8, 0.1)
	
	# tween
	var target_position = position + direction * distance
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", target_position, 0.5)
	tween.tween_property(self, "scale", Vector2(1,1), 0.3).from(Vector2(0,0))


func _process(delta):
	rotation += rotation_speed * delta


func _on_body_entered(_body):
	print(_body)
	if type == 'health':
		Globals.health += 10
	elif type == 'laser':
		Globals.laser_amount += 5
	elif type == 'grenade':
		Globals.grenade_amount += 1
	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
