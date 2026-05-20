extends TextureButton

@export var path_to_back := "res://scenes/main_menu/main_menu.tscn"

func _on_pressed() -> void:
	await SceneTrasition.fade_in(0.8)
	get_tree().change_scene_to_file(path_to_back)
	await SceneTrasition.fade_out(0.8)
