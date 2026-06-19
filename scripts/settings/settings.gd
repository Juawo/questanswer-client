extends Control
var music_volume := 100.0
@onready var music_label: Label = $MarginContainer/panel_container/MarginContainer2/MarginContainer/VBoxContainer/content/music_settings/MarginContainer/music_setting/HBoxContainer/value
@onready var msc_value: HSlider = $MarginContainer/panel_container/MarginContainer2/MarginContainer/VBoxContainer/content/music_settings/MarginContainer/music_setting/HBoxContainer/msc_value
var sfx_volume := 100.0
@onready var sfx_value: HSlider = $MarginContainer/panel_container/MarginContainer2/MarginContainer/VBoxContainer/content/sfx_settings/MarginContainer/music_setting/HBoxContainer/sfx_value
@onready var sfx_label: Label = $MarginContainer/panel_container/MarginContainer2/MarginContainer/VBoxContainer/content/sfx_settings/MarginContainer/music_setting/HBoxContainer/value

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("show")
	msc_value.value = SaveManager.music_volume
	sfx_value.value = SaveManager.sfx_volume
	music_label.text = str(int(SaveManager.music_volume)) + "%"
	sfx_label.text = str(int(SaveManager.sfx_volume)) + "%"

func _on_msc_value_value_changed(value: float) -> void:
	music_label.text = str(int(value)) + "%"
	music_volume = value
	AudioManager.update_volume_music(value)

func _on_sfx_value_value_changed(value: float) -> void:
	sfx_label.text = str(int(value)) + "%"
	sfx_volume = value
	AudioManager.update_volume_sfx(value)

func _on_close_btn_pressed() -> void:
	AudioManager.play_button()
	SaveManager.sfx_volume = sfx_volume
	SaveManager.music_volume = music_volume
	SaveManager.save_data()
	animation_player.play_backwards("show")
	await animation_player.animation_finished
	queue_free()
