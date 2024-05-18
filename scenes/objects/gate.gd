extends StaticBody2D

signal player_entered_gate

func _on_area_2d_body_entered(_body):
	print("body has entered")
	player_entered_gate.emit()
