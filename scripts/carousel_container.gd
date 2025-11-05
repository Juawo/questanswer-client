@tool
extends Node2D
class_name CarouselContainer

@export var drag_threshold: float = 35.0 # Distância mínima em pixels para registrar um swipe
var is_dragging: bool = false
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
@export var selected_index : int = 0;
@export var follow_button_focus : bool = false;

@export var position_offset_node : Control = null;

var cards_num : int

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return
	
	selected_index = clamp(selected_index, 0, position_offset_node.get_child_count() - 1);
	
	for i in position_offset_node.get_children():
		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0);
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI;
			var x = sin(angle) * wraparound_radius;
			var y = cos(angle) * wraparound_height;
			var target_pos = Vector2(x, y-wraparound_height) - i.size/2.0;
			i.position = lerp(i.position, target_pos, smoothing_speed * delta);
		else:
			var position_x = 0;
			if i.get_index() > 0:
				position_x = position_offset_node.get_child(i.get_index() - 1).position.x + position_offset_node.get_child(i.get_index()-1).size.x + spacing;
			i.position = Vector2(position_x, -i.size.y / 2.0);
		
		i.pivot_offset = i.size/2.0;
		
		var target_scale = 1.0 - (scale_strength * abs(i.get_index()-selected_index));
		target_scale = clamp(target_scale, scale_min, 1.0);
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed*delta);
		
		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index()-selected_index));
		target_opacity = clamp(target_opacity, 0.0, 1.0);
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed*delta);
		
		if i.get_index() == selected_index:
			i.z_index = 1;
			i.mouse_filter = Control.MOUSE_FILTER_STOP;
			i.focus_mode = Control.FOCUS_ALL;
		else:
			i.z_index = -abs(i.get_index()-selected_index);
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE;
			i.focus_mode = Control.FOCUS_NONE;
		if follow_button_focus and i.has_focus():
			selected_index = i.get_index();
			
	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed*delta);
	else:
		position_offset_node.position.x = lerp(position_offset_node.position.x, -(position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x / 2.0), smoothing_speed * delta);

func setup() -> void:
	if position_offset_node:
		cards_num = position_offset_node.get_child_count()
		print(cards_num)
		update_selected_index(0)
	else:
		print("position_offset_node nao existe")
		
func _left():
	update_selected_index(selected_index - 1)
	if  selected_index < 0:
		update_selected_index(selected_index + 1)

func _right():
	update_selected_index(selected_index + 1)
	if selected_index > position_offset_node.get_child_count()-1:
		update_selected_index(selected_index - 1)

func update_selected_index(new_index : int) -> void:
	print(new_index)
	var old_card_selected = position_offset_node.get_children()[selected_index]
	old_card_selected.back.mouse_filter = 2
	var tween = create_tween()
	tween.tween_property(self, "selected_index", new_index, 0.8)\
		 .set_trans(Tween.TRANS_LINEAR)
	var new_card_selected = position_offset_node.get_children()[new_index]
	new_card_selected.back.mouse_filter = 1
	
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
						_left() # Arrastou da direita para a esquerda
					elif drag_accumulated_distance < -drag_threshold:
						_right() # Arrastou da esquerda para a direita
					# Como foi um arrasto, AGORA consumimos o evento para
					# não acionar botões por acidente ao soltar o dedo.
					get_viewport().set_input_as_handled()
				# Se a distância foi pequena, consideramos que foi um CLIQUE.
				# E se foi um clique, não fazemos NADA aqui.
				# Simplesmente deixamos o evento seguir seu caminho até o botão.

func switch_control_state(state : bool) -> void:
	scroll_activated = state
