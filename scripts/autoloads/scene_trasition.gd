extends CanvasLayer

signal transition_finished

@onready var transition_texture: ColorRect = $transition_texture
@onready var loading_ui: VBoxContainer = $MarginContainer/Control/loading_ui

func _ready() -> void:
	set_shader_progress(0.0)
	loading_ui.scale = Vector2.ZERO

func set_shader_progress(value: float) -> void:
	if transition_texture.material and transition_texture.material is ShaderMaterial:
		transition_texture.material.set_shader_parameter("progress", value)

func fade_in(duration: float = 0.8) -> void:
	show() 
	
	# Criamos um único pipeline de animação
	var main_tween = create_tween()
	
	# 1. Dispara o Shader para começar a preencher a tela
	main_tween.tween_method(set_shader_progress, 0.0, 1.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 2. Ativamos o modo PARALELO para o que vem a seguir rodar JUNTO com o shader
	main_tween.set_parallel(true)
	
	# Calculamos a metade do tempo para o Pop acontecer exatamente no meio
	var metade_do_tempo = duration / 2.0
	
	# Dispara o Pop In com o delay para bater no meio da transição
	main_tween.tween_property(loading_ui, "scale", Vector2(1.2, 1.2), 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(metade_do_tempo)\
		.from(Vector2.ZERO)
		
	# Voltamos para o modo SEQUENCIAL para assentar o tamanho da UI após o Pop grande
	main_tween.set_parallel(false)
	main_tween.tween_property(loading_ui, "scale", Vector2(1.0, 1.0), 0.1)
	
	# Agora sim, um único await que garante que todo esse ecossistema terminou!
	await main_tween.finished
	transition_finished.emit()

func fade_out(duration: float = 0.8) -> void:
	var main_tween = create_tween()
	
	# 1. Primeiro fazemos o Pop Out da UI (Encolher até sumir)
	main_tween.tween_property(loading_ui, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	main_tween.tween_property(loading_ui, "scale", Vector2.ZERO, 0.2)
	
	# 2. Depois que a UI sumiu por completo, o shader entra abrindo a cortina
	main_tween.tween_method(set_shader_progress, 1.0, 0.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await main_tween.finished
	hide() 
	transition_finished.emit()
