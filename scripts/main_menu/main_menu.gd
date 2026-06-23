extends Control

const OPTIONS_PANEL = preload("uid://up23p2uvtd8x")

func _on_play_btn_pressed() -> void:
	AudioManager.play_button()
	await SceneTrasition.fade_in(0.6)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/input_players_name/input_players_name.tscn")
	SceneTrasition.fade_out(0.6)
	
func _on_credits_btn_pressed() -> void:
	AudioManager.play_button()
	await SceneTrasition.fade_in(0.6)
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")
	SceneTrasition.fade_out(0.6)

func _on_exit_btn_pressed() -> void:
	AudioManager.play_button()
	get_tree().quit()


func _on_options_btn_pressed() -> void:
	var scene = OPTIONS_PANEL.instantiate()
	add_child(scene)
	scene.show_panel()
