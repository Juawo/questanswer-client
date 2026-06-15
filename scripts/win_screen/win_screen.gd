extends Control

@onready var scoreboard: Control = $MarginContainer/VBoxContainer/scoreboard
@onready var title: Label = $MarginContainer/VBoxContainer/title
@onready var confetti_particle_left: GPUParticles2D = $confetti_particle_left
@onready var confetti_particle_right: GPUParticles2D = $confetti_particle_right

func _ready() -> void:
	scoreboard.populate_scoreboard_for_win_screen()
	scoreboard.update_comment(true)
	scoreboard.populate_finished.connect(_on_scoreboard_finished)

func _on_scoreboard_finished() -> void :
	confetti_particle_left.explosiveness = 1.0
	confetti_particle_right.explosiveness = 1.0
	confetti_particle_left.emitting = true
	confetti_particle_right.emitting = true
	await get_tree().create_timer(0.3).timeout
	confetti_particle_left.explosiveness = 0
	confetti_particle_right.explosiveness = 0

func _on_play_again_btn_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/input_players_name/input_players_name.tscn")
	await SceneTrasition.fade_out(0.4)
