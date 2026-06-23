extends Button

const OPTIONS_PANEL = preload("uid://up23p2uvtd8x")

func _on_pressed() -> void:
	var scene = OPTIONS_PANEL.instantiate()
	get_tree().current_scene.add_child(scene)
