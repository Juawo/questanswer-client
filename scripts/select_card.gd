extends Control

@onready var id_card_label: Label = $MarginContainer/VBoxContainer/footer/PanelContainer/MarginContainer/Label
@onready var carousel_container: CarouselContainer = $MarginContainer/VBoxContainer/carousel/CarouselContainer

var selected_index : int;
var num_cards : int;
var random_num : int;

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	selected_index = carousel_container.selected_index
	num_cards = carousel_container.cards_num
	id_card_label.text = "%s/%s" % [selected_index + 1, num_cards]

func _on_random_btn_pressed() -> void:
	if num_cards == null:
		return
	random_num = randi_range(0,num_cards)
	while (selected_index == random_num):
		random_num = randi_range(0,num_cards)
		
	var diff : int = abs(selected_index - random_num);
	for i in diff:
		if(selected_index < random_num):
			carousel_container.selected_index = selected_index + 1;
		else:
			carousel_container.selected_index = selected_index - 1;
		
