extends Control

signal manual_closed

@onready var wrapper: Control = $MarginContainer/wrapper
@onready var pages: Array[Control] = [
	$MarginContainer/wrapper/manual_pag_1,
	$MarginContainer/wrapper/manual_pag_2,
	$MarginContainer/wrapper/manual_pag_3
]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_page_idx: int = 0
var is_animating: bool = false

# Configurações estéticas da animação
const SLIDE_DISTANCE := 350.0 # Distância que a carta vai para o lado
const ROTATION_ANGLE := 6.0    # Ângulo de inclinação da carta de trás

func _ready() -> void:
	# Aguarda um frame para o Godot aplicar o Stretch e o tamanho real (664) se assentar
	await get_tree().process_frame
	
	# Agora sim, configuramos o pivot no tamanho corrigido
	for i in range(pages.size()):
		pages[i].pivot_offset = pages[i].size / 2
		pages[i].size = Vector2(332.0,697.0)
		if i == current_page_idx:
			pages[i].position.x = 0
			pages[i].rotation_degrees = 0
		else:
			pages[i].position.x = 0
			pages[i].rotation_degrees = ROTATION_ANGLE if i % 2 == 0 else -ROTATION_ANGLE
			wrapper.move_child(pages[0], pages.size() - 1)

	if animation_player.has_animation("show_cards"):
		animation_player.play("show_cards")

func next_page() -> void:
	if is_animating or current_page_idx >= pages.size() - 1:
		return
	
	_transition_page(current_page_idx, current_page_idx + 1, true)

func previous_page() -> void:
	if is_animating or current_page_idx <= 0:
		return
		
	_transition_page(current_page_idx, current_page_idx - 1, false)

func _transition_page(old_idx: int, new_idx: int, going_forward: bool) -> void:
	is_animating = true
	
	var old_card = pages[old_idx]
	var new_card = pages[new_idx]
	
	# Determina a direção do "slide" (próximo vai para a direita, anterior para a esquerda)
	var direction = 1.0 if going_forward else -1.0
	
	# Dispara o som de slide que configuramos no AudioManager!
	if signup_autoload_exists("AudioManager"):
		AudioManager.play_card_slide(going_forward)

	# --- FASE 1: O AFASTAMENTO EM PARALELO ---
	var tween_out = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Carta atual sai para o lado e perde rotação
	tween_out.tween_property(old_card, "position:x", SLIDE_DISTANCE * direction, 0.4)
	tween_out.tween_property(old_card, "rotation_degrees", 0.0, 0.4)
	
	# Nova carta dá uma leve escapada para o lado oposto para criar dinâmica
	tween_out.tween_property(new_card, "position:x", -50.0 * direction, 0.4)
	
	await tween_out.finished
	
	# --- FASE 2: A TROCA DE LUGAR NA PILHA (Z-INDEX) ---
	# Move a nova carta para o topo da hierarquia visual do wrapper
	wrapper.move_child(new_card,wrapper.get_child_count() - 1)
	# Joga a carta antiga para a base da pilha
	wrapper.move_child(old_card, 0)
	
	# Sorteia uma rotação charmosa de "carta guardada na pilha" para a carta antiga
	var random_rot = randf_range(-ROTATION_ANGLE, ROTATION_ANGLE)
	
	# --- FASE 3: O RETORNO AO CENTRO ---
	var tween_in = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Carta antiga volta para o centro ficando atrás com a rotação de espera
	tween_in.tween_property(old_card, "position:x", 0.0, 0.3)
	tween_in.tween_property(old_card, "rotation_degrees", random_rot, 0.3)
	
	# Nova carta assume o centro majestosa e sem rotação nenhuma
	tween_in.tween_property(new_card, "position:x", 0.0, 0.3)
	tween_in.tween_property(new_card, "rotation_degrees", 0.0, 0.3)
	
	await tween_in.finished
	
	# Atualiza o índice da página atual e libera o botão
	current_page_idx = new_idx
	is_animating = false

# Função utilitária apenas para checar se o AudioManager está ativo no projeto
func signup_autoload_exists(autoload_name: String) -> bool:
	return has_node("/root/" + autoload_name)

func _on_next_btn_pressed() -> void:
	next_page()

func _on_previous_btn_pressed() -> void:
	previous_page()

func _close() -> void :
	manual_closed.emit()
	animation_player.play_backwards("show_cards")
	await animation_player.animation_finished
	queue_free()

func _on_close_btn_pressed() -> void:
	_close()
