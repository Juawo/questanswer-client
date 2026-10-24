extends Control

@onready var scoreboard: Control = $MarginContainer/VBoxContainer/scoreboard_wrapper/scoreboard
@onready var title: Label = $MarginContainer/VBoxContainer/wrapper/title
@onready var confetti_particle_left: GPUParticles2D = $confetti_particle_left
@onready var confetti_particle_right: GPUParticles2D = $confetti_particle_right
@onready var play_again_btn: Button = $MarginContainer/VBoxContainer/btn_wrapper/play_again_btn
var winner_name := "PLAYER1029"

func _ready() -> void:
	AudioManager.switch_to_win_music()
	await get_tree().create_timer(0.8).timeout
	scoreboard.populate_scoreboard_for_win_screen()
	scoreboard.update_comment(true)
	scoreboard.populate_finished.connect(_on_scoreboard_finished)
	SessionState.player_win.connect(_on_player_win)
	title.text = SessionState.winner_name + "\nGANHOU!!!"

func _on_player_win(player_name : String) -> void :
	winner_name = player_name

func _on_scoreboard_finished() -> void :
	confetti_particle_left.explosiveness = 1.0
	confetti_particle_right.explosiveness = 1.0
	confetti_particle_left.emitting = true
	confetti_particle_right.emitting = true
	AudioManager.play_confetti()
	await get_tree().create_timer(0.5).timeout
	confetti_particle_left.explosiveness = 0
	confetti_particle_right.explosiveness = 0
	
	var title_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	title_tween.tween_property(title, "position", Vector2.ZERO, 0.4)

	var btn_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	btn_tween.tween_property(play_again_btn, "position:y", 0, 0.4)

	var scoreboard_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scoreboard_tween.tween_property(scoreboard, "position", Vector2.ZERO, 0.4)
	await scoreboard_tween.finished
	await get_tree().create_timer(0.3).timeout
	play_again_btn.disabled = false

func _on_play_again_btn_pressed() -> void:
	AudioManager.play_button()
	AudioManager.reset_to_base_music()
	await SceneTrasition.fade_in(0.6)
	get_tree().change_scene_to_file("res://scenes/input_players_name/input_players_name.tscn")
	SceneTrasition.fade_out(0.4)
