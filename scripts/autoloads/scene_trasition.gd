extends CanvasLayer

signal transition_finished

@onready var transition_texture: ColorRect = $transition_texture

var rotation_tween: Tween

func _ready() -> void:
	# Garante que o shader comece totalmente invisível (progress = 0)
	set_shader_progress(0.0)

# Função auxiliar para mudar o parâmetro do shader com segurança
func set_shader_progress(value: float) -> void:
	if transition_texture.material and transition_texture.material is ShaderMaterial:
		transition_texture.material.set_shader_parameter("progress", value)

# 2. Animação para APARECER a tela (Fade In)
func fade_in(duration: float = 0.5) -> void:
	show() # Garante que a CanvasLayer está visível
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Anima o progresso do shader de 0.0 para 1.0
	tween.tween_method(set_shader_progress, 0.0, 1.0, duration)
	
	await tween.finished
	transition_finished.emit()

# 3. Animação para SUMIR a tela (Fade Out)
func fade_out(duration: float = 0.5) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Anima o progresso do shader de 1.0 para 0.0
	tween.tween_method(set_shader_progress, 1.0, 0.0, duration)
	
	await tween.finished
	hide() # Esconde a CanvasLayer para não bloquear cliques no menu
	transition_finished.emit()
