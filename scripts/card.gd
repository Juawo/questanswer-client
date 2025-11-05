extends Control

signal flip_requested
signal close_requested
signal card_played()
signal card_selected(card_data)

enum MODE { CAROUSEL , MODAL }
var current_mode: MODE = MODE.CAROUSEL
var card_data: CardData;
var id : int
var card_modal_scene : PackedScene = load("res://scenes/card_modal.tscn")

@onready var answer: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/term_card/term_card/Label2
@onready var category: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/type_card/MarginContainer/VBoxContainer/Label2
@onready var tips: VBoxContainer = $front/MarginContainer/VBoxContainer/tips
@onready var back: TextureButton = $back

func populate_front(data: CardData):
	self.card_data = data
	if(is_instance_valid(card_data)):
		answer.text = card_data.answer
		category.text = card_data.category
		for i in range(tips.get_child_count()):
			if i < card_data.tips.size():
				var tip = tips.get_child(i)
				var text_for_tip = "%d. %s" % [i+1, card_data.tips[i]]
				tip.set_tip_text(text_for_tip)

func _on_back_pressed() -> void:
		match current_mode:
			MODE.CAROUSEL:
				print("CARTA SELECIONADA -> %s" % card_data.answer)
				emit_signal("card_selected", card_data)
			MODE.MODAL:
				emit_signal("flip_requested")
	
func _on_played_btn_pressed() -> void:
	SaveManager.add_played_card(self.card_data.id)
	emit_signal("card_played")
	emit_signal("close_requested")

func _on_close_btn_pressed() -> void:
	if current_mode == MODE.MODAL:
		emit_signal("close_requested")
