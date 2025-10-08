extends Control

@onready var id_card_label: Label = $MarginContainer/VBoxContainer/footer/PanelContainer/MarginContainer/Label
@onready var carousel_container: CarouselContainer = $MarginContainer/VBoxContainer/carousel/CarouselContainer

var selected_index : int;
var num_cards : int;
var random_index : int;

func _ready() -> void:
	randomize()

func _process(_delta: float) -> void:
	selected_index = carousel_container.selected_index
	num_cards = len(SessionState.cards_from_database)
	id_card_label.text = "%s/%s" % [selected_index + 1, num_cards]

func _on_random_btn_pressed() -> void:
	if num_cards == 0:
		return
	# Sorteia um novo índice, garantindo que seja diferente do atual
	random_index = randi_range(0, num_cards - 1) # Correção: o índice máximo é size - 1
	while random_index == selected_index:
		random_index = randi_range(0, num_cards -1)
	print("Índice Atual: %d, Sorteado: %d" % [selected_index, random_index])
	
	var tween = create_tween()
	tween.tween_property(carousel_container, "selected_index", random_index, 0.8)\
		 .set_trans(Tween.TRANS_LINEAR)
