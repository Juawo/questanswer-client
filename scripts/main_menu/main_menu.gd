extends Control

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/select_card/select_card.tscn")

func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
