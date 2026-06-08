extends Control

@onready var title: Label = $MarginContainer/wrapper/VBoxContainer/VBoxContainer/title
@onready var sequence_content: Label = $MarginContainer/wrapper/VBoxContainer/VBoxContainer2/sequence_content
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# TODO : Quando mudar o questioner precisa aparecer com ele mudado
# TODO : Adicionar abaixo da carta de quem e a vez
# TODO : Adicionar mecanismo de passar a vez pos uma dica ser usada
# TODO : 

func _ready() -> void:
	show_screen()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		hide_screen()

func show_screen() -> void :
	populate_screen(SessionState.get_questioner_name(), SessionState.get_guessers_sequence_name())
	animation_player.play("show_screen")
	await animation_player.animation_finished
	animation_player.play("toutch_blink")

func hide_screen() -> void :
	animation_player.play_backwards("show_screen")
	await animation_player.animation_finished
	queue_free()

func populate_screen(questioner_name : String, guessers_sequence : Array[String]) -> void :
		title.text = questioner_name + "\n é o mestre!"
		sequence_content.text = ""
		for i in range(guessers_sequence.size()):
			if i == guessers_sequence.size() - 1:
				sequence_content.text += guessers_sequence[i]
			else :
				sequence_content.text += guessers_sequence[i] + ", "
