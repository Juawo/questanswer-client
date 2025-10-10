extends Control

signal flip_requested
signal close_requested


enum Mode { CAROUSEL, MODAL }
var card_data: CardData;
var id : int
var current_mode: Mode = Mode.CAROUSEL
var card_modal_scene : PackedScene = load("res://scenes/card_modal.tscn")

@onready var answer: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/term_card/term_card/Label2
@onready var category: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/type_card/MarginContainer/VBoxContainer/Label2
@onready var tips: VBoxContainer = $front/MarginContainer/VBoxContainer/tips


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
		Mode.CAROUSEL:
			if(card_data == null):
				printerr("Erro: nao ha dados para exibir a carta")
				return
			var modal_instance = card_modal_scene.instantiate()
			get_tree().root.add_child(modal_instance)
			modal_instance.set_card_data(self.card_data)
		Mode.MODAL:
			emit_signal("flip_requested")
	
func _on_played_btn_pressed() -> void:
	SaveManager.add_played_card(self.card_data.id)
	if current_mode == Mode.MODAL:
		emit_signal("close_requested")

func _on_close_btn_pressed() -> void:
	if current_mode == Mode.MODAL:
		emit_signal("close_requested")
