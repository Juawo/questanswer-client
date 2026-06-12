@tool
extends PanelContainer

# TODO : adicionar os estilos para cada tipo de posicao 1-5
# TODO : adicionar animacao juice na trasicao de ranks

@export var rank_position : int : set = update_rank_position_visual
@export var player_name : String : set = update_player_name
@export var player_score : int : set = update_player_score

@onready var player_name_label: Label = $MarginContainer/HBoxContainer/player_name
@onready var player_score_label: Label = $MarginContainer/HBoxContainer/player_score

@onready var rank_icon: TextureRect = $MarginContainer/HBoxContainer/Control/rank_icon
@onready var rank_position_label: Label = $MarginContainer/HBoxContainer/Control/rank_icon/MarginContainer/rank_position
@onready var margin_container: MarginContainer = $MarginContainer/HBoxContainer/Control/rank_icon/MarginContainer

func update_player_name(new_value : String) -> void :
	player_name = new_value
	
	if not is_node_ready() :
		await ready
		
	player_name_label.text = player_name

func update_player_score(new_value : int) -> void :
	player_score = new_value
	
	if not is_node_ready() :
		await ready
		
	player_score_label.text = str(player_score) + "pts"


func update_rank_position_visual(new_value : int) -> void :
	rank_position = new_value
	
	if not is_node_ready() :
		await ready
	
	match  rank_position :
		1 : 
			rank_icon.texture = preload("uid://do28osyko4pxh")
			margin_container.visible = false
		2 :
			rank_icon.texture = preload("uid://c2oqxnhs1mads")
			margin_container.visible = false
		3 :
			rank_icon.texture = preload("uid://b7060adodfxpe")
			margin_container.visible = false
		_:
			rank_icon.texture = null
			rank_position_label.text = str(rank_position)
			margin_container.visible = true
