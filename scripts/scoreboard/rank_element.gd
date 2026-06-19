@tool
extends PanelContainer

@export var rank_position : int : 
	set(new_value) :
		rank_position = new_value
		if not is_node_ready() :
			await ready
		animate_rank_change(new_value)

@export var player_name : String : set = update_player_name
@export var player_score : int : set = update_player_score

@onready var player_name_label: Label = $MarginContainer/HBoxContainer/player_name
@onready var player_score_label: Label = $MarginContainer/HBoxContainer/player_score

@onready var rank_icon: TextureRect = $MarginContainer/HBoxContainer/Control/rank_icon
@onready var rank_position_label: Label = $MarginContainer/HBoxContainer/Control/rank_icon/MarginContainer/rank_position
@onready var margin_container: MarginContainer = $MarginContainer/HBoxContainer/Control/rank_icon/MarginContainer

var current_displayed_score : int = 0

func _ready() -> void:
	pivot_offset = size/2

func populate_rank_element(playername, score) -> void :
	update_player_name(playername)
	update_player_score(score)

func update_player_name(new_value : String) -> void :
	player_name = new_value
	
	if not is_node_ready() :
		await ready
		
	player_name_label.text = player_name

func update_player_score(new_value : int) -> void :
	player_score = new_value
	
	if not is_node_ready() :
		await ready
		
	animate_score_counter(new_value, 0.5)

func update_rank_position_visual(new_value : int) -> void :
	rank_icon.visible = true
	match  new_value :
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
	AudioManager.play_pop_up()
	

func animate_rank_change(target_position : int) -> void :
	var random_rotation = randf_range(-15.0,15.0)
	var tween = create_tween()
	
	tween.tween_property(rank_icon, "scale", Vector2(0.3,0.3), 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(rank_icon, "rotation_degrees", random_rotation, 0.15)
	
	update_rank_position_visual(target_position)
	
	var tween_back = create_tween()
	tween_back.tween_property(rank_icon, "scale", Vector2(1.0,1.0), 0.35)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)\
	.from(Vector2(1.3,1.3))
	
	tween_back.tween_property(rank_icon, "rotation_degrees", 0.0, 0.3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)

func animate_score_counter(target_score : int, duration : float) -> void :
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(_update_score_text, current_displayed_score, target_score, duration)
	var text_tween = create_tween()
	text_tween.tween_property(player_score_label, "scale", Vector2(1.2,1.2), 0.1)
	text_tween.tween_property(player_score_label, "scale", Vector2(1.0,1.0), 0.1)
	current_displayed_score = target_score

func _update_score_text(value : int) -> void :
	player_score_label.text = str(value) + "pts"
