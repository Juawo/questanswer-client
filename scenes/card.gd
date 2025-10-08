extends Control

var card_data: CardData;

@onready var term: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/term_card/term_card/Label2
@onready var category: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/type_card/MarginContainer/VBoxContainer/Label2
@onready var tips: VBoxContainer = $front/MarginContainer/VBoxContainer/tips

func populate_front(data: CardData):
	self.card_data = data
	if(is_instance_valid(card_data)):
		term.text = card_data.term
		category.text = card_data.category
		for i in range(tips.get_child_count()):
			if i < card_data.tips.size():
				var tip = tips.get_child(i)
				tip.tip_text = "%d. %s" % [i+1, card_data.tips[i]]


func _on_back_pressed() -> void:
	print("opa")
	if(card_data != null):
		print(card_data.term)
		print(card_data.category)
		print(card_data.tips)
		
