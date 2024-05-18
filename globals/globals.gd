extends Node

signal stat_change

var player_hit_sound: AudioStreamPlayer

var laser_amount: int = 20:
	set(value):
		laser_amount = value
		stat_change.emit()
		
var grenade_amount: int = 5:
	set(value):
		grenade_amount = value
		stat_change.emit()

var player_vulnerable: bool = true
var health = 60:
	set(value):
		if value > health:
			health = min(value, 100)
		elif player_vulnerable:
			health = value
			player_vulnerable = false
			player_invulnerable_timer()
			player_hit_sound.play()
		stat_change.emit()

var player_pos: Vector2

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true
	
func _ready():
	player_hit_sound = AudioStreamPlayer.new()
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")
	add_child(player_hit_sound)

