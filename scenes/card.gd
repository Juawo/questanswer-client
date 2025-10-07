extends Control

var card_data: CardData;

@onready var term: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/term_card/term_card/Label2
@onready var category: Label = $front/MarginContainer/VBoxContainer/header_card/header_card/type_card/MarginContainer/VBoxContainer/Label2
@onready var tips: VBoxContainer = $front/MarginContainer/VBoxContainer/tips

func fill_front_card(data: CardData):
	self.card_data = data
	
	if(is_instance_valid(card_data)):
		term.text = card_data.term
		category.text = card_data.category
		for i in (tips.get_child_count()):
			if i < card_data.hints.size():
				var tip = tips.get_child(i)
				tip.tip_text = "%d. %s" % [i+1, card_data.dicas[i]]
