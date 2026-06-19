extends Control

signal panel_closed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const SETTINGS = preload("uid://dixwle8bol7r")
const MANUAL = preload("uid://dulrrba8qo6u8")

func _ready() -> void:
	visible = false

func show_panel() -> void :
	visible = true
	animation_player.play("show")

func _on_help_btn_pressed() -> void:
	show_manual()

func show_manual() -> void:
	var scene = MANUAL.instantiate()
	get_tree().current_scene.add_child(scene)


func _on_settigns_btn_pressed() -> void:
	var scene = SETTINGS.instantiate()
	add_child(scene)

func _on_close_btn_pressed() -> void:
	close()

func close() -> void:
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	visible = false
	panel_closed.emit()
