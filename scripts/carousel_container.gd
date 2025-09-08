@tool
extends Node2D
class_name CarouselContainer

#test
@export var drag_threshold: float = 50.0 # Distância mínima em pixels para registrar um swipe
var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var drag_accumulated_distance: float = 0.0

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

func _ready() -> void:
	if position_offset_node:
		cards_num = position_offset_node.get_child_count()

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


func _left():
	selected_index -= 1;
	if  selected_index < 0:
		selected_index += 1

func _right():
	selected_index += 1
	if selected_index > position_offset_node.get_child_count()-1:
		selected_index -= 1

func _input(event: InputEvent) -> void:
	# --- Início do Arraste ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() \
	or event is InputEventScreenTouch and event.is_pressed():
		
		# Pegamos o nó pai e verificamos se ele é um Control
		var parent_control = get_parent() as Control
		
		# Verificamos se o clique foi dentro da área do pai
		if parent_control and parent_control.get_global_rect().has_point(event.position):
			is_dragging = true
			drag_start_position = event.position
			drag_accumulated_distance = 0.0
			get_viewport().set_input_as_handled()

	# --- Fim do Arraste ---
	# Detecta se o botão esquerdo do mouse ou o toque na tela foi solto
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed() \
	or event is InputEventScreenTouch and not event.is_pressed():
		if is_dragging:
			is_dragging = false
			# Verifica se a distância arrastada ultrapassou o nosso limite
			if drag_accumulated_distance > drag_threshold:
				_left() # Arrastou da direita para a esquerda
			elif drag_accumulated_distance < -drag_threshold:
				_right() # Arrastou da esquerda para a direita
	
	# --- Durante o Arraste ---
	# Detecta o movimento do mouse ou do dedo na tela
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if is_dragging:
			# Calcula a distância total desde o ponto inicial
			drag_accumulated_distance = event.position.x - drag_start_position.x
