extends LevelParent

# var inside_level_scene: PackedScene = preload("res://scenes/levels/inside.tscn")

func _on_gate_player_entered_gate():
	var tween = create_tween() # create_tree() is not required
	tween.tween_property($Player, "speed", 0, 0.5)
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")
	# get_tree().change_scene_to_file("res://scenes/levels/inside.tscn")
	# get_tree().change_scene_to_packed(inside_level_scene)

func _on_house_player_entered():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1, 1), 1).set_trans(Tween.TRANS_SINE)
	# tween.tween_property($Player, "modulate:a", 0, 2).from(0.5)
	
func _on_house_player_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.6, 0.6), 1).set_trans(Tween.TRANS_SINE) # 2
