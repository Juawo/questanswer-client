extends Control

@onready var background: ColorRect = $background
@onready var card_placeholder: Control = $card_placeholder
var card_scene_template: PackedScene = preload("res://scenes/card.tscn")

var displayed_card_data : CardData
var current_card_scene
var is_front_showing : bool

func _ready() -> void:
	background.visible = false
	background.gui_input.connect(_on_background_clicked)
	print("Card modal ready")

func set_card_data(card_data: CardData):
	displayed_card_data = card_data
	print("Displayed card data : ", displayed_card_data.answer)
	init_modal()

func init_modal():
	print("modal iniciado")
	if not is_instance_valid(card_placeholder) :
		printerr("Erro: Placeholder nao encontrado no cardModal!")
		return
	
	if  not is_instance_valid(displayed_card_data):
		printerr("Erro: DisplayedCard nao encontrado no cardModal!")
		return
	
	current_card_scene = card_scene_template.instantiate()
	
	print(current_card_scene)
	card_placeholder.add_child(current_card_scene)
	current_card_scene.current_mode = current_card_scene.Mode.MODAL
	current_card_scene.flip_requested.connect(turn_card_animation)
	current_card_scene.close_requested.connect(close_modal_animation)
	
	current_card_scene.populate_front(displayed_card_data)
	current_card_scene.z_index = 2
	open_modal_animation()

func open_modal_animation():
	background.visible = true
	background.z_index = 1
	var tween = create_tween()
	current_card_scene.position = Vector2(get_viewport_rect().size.x / 2 - current_card_scene.size.x / 2, \
	get_viewport_rect().size.y / 2 - current_card_scene.size.y / 2)
	current_card_scene.scale = Vector2(0.5,0.5)
	tween.tween_property(current_card_scene, "scale", Vector2(1,1), 0.4).set_trans(Tween.TRANS_BACK)

func turn_card_animation():
	var tween = create_tween()
	is_front_showing = not is_front_showing
	var front_node = current_card_scene.find_child("front")
	var back_node = current_card_scene.find_child("back")
	
	tween.tween_property(current_card_scene, "scale", Vector2(0.01,1), 0.2).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	
	if is_front_showing:
		front_node.visible = true
		back_node.visible = false
	else:
		front_node.visible = false
		back_node.visible = true
	
	tween = create_tween()
	tween.tween_property(current_card_scene, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUAD)
	
func _on_background_clicked(event: InputEvent):
		if event.is_action("ui_accept"):
			close_modal_animation()

func close_modal_animation():
	var tween = create_tween()
	tween.tween_property(current_card_scene, "scale", Vector2(0.5,0.5), 0.3).set_trans(Tween.TRANS_BACK)
	tween.tween_property(current_card_scene, "modulate", Color(0,0,0,0), 0.3)
	
	tween.tween_property(background, "modulate", Color(0,0,0,0), 0.3)
	tween.tween_callback(func(): background.visible = false)
	
	await  tween.finished
	queue_free()
	
	
	





	
	
	
	
	
	
