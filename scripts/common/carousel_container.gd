extends Node2D
class_name CarouselContainer

signal _on_selected_index_changed(new_index : int)
signal _on_number_of_child_changed(new_count : int)

@export var drag_threshold: float = 35.0 # Distância mínima em pixels para registrar um swipe
var is_dragging: bool = false : 
	set(value) :
		is_dragging = value
		if is_dragging:
			set_process(true)
		
var drag_start_position: Vector2 = Vector2.ZERO
var drag_accumulated_distance: float = 0.0
var scroll_activated: bool = true
@export var spacing:float = 20.0;

@export var wraparound_enabled: bool = false;
@export var wraparound_radius: float = 300.0;
@export var wraparound_height: float = 50.0;

@export_range(0.0, 1.0) var opacity_strength : float = 0.35;
@export_range(0.0, 1.0) var scale_strength : float = 0.25;
@export_range(0.0, 1.0) var scale_min : float = 0.1;

@export var smoothing_speed : float = 6.5;
@export var selected_index : int = 0 
@export var follow_button_focus : bool = false;

@export var position_offset_node : Control = null;

var cards_num : int
var selection_tween : Tween

func _ready() -> void:
	setup()
	set_process(false)

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		set_process(false)
		return

	var children = position_offset_node.get_children()
	var num_children = children.size()
	selected_index = clamp(selected_index, 0, num_children - 1)
	var is_any_card_moving := false
	
	for i in children:
		if i.is_queued_for_deletion() : continue
		var target_pos : Vector2
		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0);
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI;
			var x = sin(angle) * wraparound_radius;
			var y = cos(angle) * wraparound_height;
			target_pos = Vector2(x, y-wraparound_height) - i.size/2.0;
			i.position = lerp(i.position, target_pos, smoothing_speed * delta);
		else:
			var position_x = 0;
			if i.get_index() > 0:
				position_x = children[i.get_index() - 1].position.x + children[i.get_index()-1].size.x + spacing
			target_pos = Vector2(position_x, -i.size.y / 2.0)
		
		i.position = i.position.lerp(target_pos, smoothing_speed * delta)
		
		var dist = abs(i.get_index() - selected_index)
		var target_scale_val = clamp(1.0 - (scale_strength * dist), scale_min, 1.0)
		i.scale = i.scale.lerp(Vector2.ONE * target_scale_val, smoothing_speed * delta)
		
		var target_alpha = clamp(1.0 - (opacity_strength * dist), 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_alpha, smoothing_speed * delta)

		# Verificação de movimento individual da carta
		if i.position.distance_to(target_pos) > 0.1:
			is_any_card_moving = true
			
	var target_x : float = 0.0
	if !wraparound_enabled:
		var selected_node = children[int(selected_index)]
		target_x = -(selected_node.position.x + selected_node.size.x / 2.0)
	
	position_offset_node.position.x = lerp(position_offset_node.position.x, target_x, smoothing_speed * delta)

	var is_tweening = selection_tween and selection_tween.is_running()
	
	if !is_dragging and !is_tweening:
		var distance_to_target = abs(position_offset_node.position.x - target_x)
		
		# Só desliga se o container parou E as cartas individuais pararam
		if distance_to_target < 0.05 and !is_any_card_moving:
			position_offset_node.position.x = target_x
			set_process(false)

func _input(event: InputEvent) -> void:    
	if scroll_activated:
		# --- Início da Ação (Pressionar) ---
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() \
		or event is InputEventScreenTouch and event.is_pressed():
			# Apenas registramos o início. NÃO consumimos o evento ainda!
			is_dragging = true
			drag_start_position = event.position
			drag_accumulated_distance = 0.0

		# --- Durante o Movimento ---
		if (event is InputEventMouseMotion or event is InputEventScreenDrag) and is_dragging:
			# Apenas calculamos a distância percorrida
			drag_accumulated_distance = event.position.x - drag_start_position.x

		# --- Fim da Ação (Soltar) ---
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed() \
		or event is InputEventScreenTouch and not event.is_pressed():
			if is_dragging:
				is_dragging = false
				
			# AGORA tomamos a decisão:
			# Se a distância foi grande o suficiente, é um ARRASTO.
				if abs(drag_accumulated_distance) > drag_threshold:
					if drag_accumulated_distance > drag_threshold:
						_left() 
					elif drag_accumulated_distance < -drag_threshold:
						_right()
					# Como foi um arrasto, AGORA consumimos o evento para
					# não acionar botões por acidente ao soltar o dedo.
					get_viewport().set_input_as_handled()
				# Se a distância foi pequena, consideramos que foi um CLIQUE.
				# E se foi um clique, não fazemos NADA aqui.
				# Simplesmente deixamos o evento seguir seu caminho até o botão.

func setup() -> void:
	if position_offset_node:
		cards_num = position_offset_node.get_child_count()
		_on_number_of_child_changed.emit(cards_num)
		
		print("Carrousel Container - Cards Num : ", cards_num)
		update_selected_index(0)
	else:
		print("position_offset_node nao existe")
		
func _left():
	if  selected_index <= 0:
		update_selected_index(0)
	else:
		update_selected_index(selected_index - 1)
	AudioManager.play_card_slide(false)

func _right():
	if selected_index >= position_offset_node.get_child_count()-1:
		update_selected_index(position_offset_node.get_child_count()-1)
	else :
		update_selected_index(selected_index + 1)
	AudioManager.play_card_slide(true)

func update_selected_index(new_index : int) -> void:
	var children = position_offset_node.get_children()
	var size = children.size()
	
	if new_index < 0 or new_index >= size:
		return
	
	if selection_tween:
		selection_tween.kill()
	
	selection_tween = create_tween()
	
	for card in children:
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	selection_tween.tween_property(self, "selected_index", float(new_index), 0.4)\
		 .set_trans(Tween.TRANS_LINEAR)
	set_process(true)
	
	_on_selected_index_changed.emit(new_index)
	selection_tween.parallel().tween_callback(func(): 
		_update_visual_depth(new_index)
	).set_delay(0.2) # Meio da animação

func _update_visual_depth(new_index: int) -> void:
	var children = position_offset_node.get_children()
	for card in children:
		var idx = card.get_index()
		if idx == new_index:
			card.z_index = 1 # Um valor alto para garantir o topo
			card.mouse_filter = Control.MOUSE_FILTER_STOP
			card.back.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			# Cartas laterais ficam com z-index negativo baseado na distância
			card.z_index = -abs(idx - new_index)
			card.mouse_filter = Control.MOUSE_FILTER_IGNORE

func switch_control_state(state : bool) -> void:
	scroll_activated = state
