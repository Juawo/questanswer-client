extends Control

func _on_play_btn_pressed() -> void:
	await SceneTrasition.fade_in(1)
	if SessionState.cards_from_database.is_empty() :
		ApiManager.fetch_unplayed_cards()
		await ApiManager.cards_fetched_sucessfully
	else :
		await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/select_card/select_card.tscn")
	SceneTrasition.fade_out(1)
	
func _on_credits_btn_pressed() -> void:
	await SceneTrasition.fade_in(0.8)
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")
	SceneTrasition.fade_out(0.8)
	

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
