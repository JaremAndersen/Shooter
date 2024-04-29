extends LevelParent
 
func _on_gate_player_entered_gate(_body):
	print("entered gate")
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.5)
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")


func _on_house_player_entered():
	var tween = get_tree().create_tween()
	print("in house?")
	tween.tween_property($Player/Camera2D, "zoom", Vector2(.6,.6), 1).set_trans(Tween.TRANS_SPRING)


func _on_house_player_exited():
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(.4,.4), 1)
	