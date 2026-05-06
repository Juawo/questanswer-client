extends TextureButton

@export var path_to_back := "res://scenes/main_menu/main_menu.tscn"

func _on_pressed() -> void:
	get_tree().change_scene_to_file(path_to_back)
