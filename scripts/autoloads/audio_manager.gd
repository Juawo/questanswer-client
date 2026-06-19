extends Node

# --- MUSIC ---
var MUSIC_BASE = preload("uid://bpbqtdn2hhsqd")
var WIN_MUSIC_1 = preload("uid://c64kqvopxuigl")
var WIN_MUSIC_2 = preload("uid://btxrywxcqkbet")

# --- (SFX) ---
const ALARM_SFX = preload("uid://l2e1pr7m55yp")
var CLOCK_COUNTING_SFX = preload("uid://w8f1nk1kl88l")

const RANDOM_CARD_SFX = preload("uid://be0c5fy8nqji8")
const CARD_OPEN_SFX = preload("uid://bdyuwwydnlh8g")
const CARD_CLOSE_SFX = preload("uid://cr0rxjgpjss30")
const CARD_SLIDE_PREVIOUS_SFX = preload("uid://c1187amq85ya")
const CARD_SLIDE_NEXT_SFX = preload("uid://cdbs7xgka0y53")
const CARD_TURN_SFX = preload("uid://ok7f7xx7ss2")

const SWITCH_004 = preload("uid://bgqghigkpamvq")
const SWITCH_005 = preload("uid://cucnbqur5kyfm")

const CONFETTI = preload("uid://c4u4glm7006mk")

const CORRECT = preload("uid://bm0yoknf07dr7")
const INCORRECT = preload("uid://x8ix4g5kws77")

const SLIDEPOP = preload("uid://chm844b74y3pv")
const POP_UP = preload("uid://cyekxl0aprd6e")

# Player fixo na memória para a música de fundo
var music_player: AudioStreamPlayer
var clock_player: AudioStreamPlayer

var lowpass_effect_idx: int = 0
var music_bus_idx: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Garante que o som toca mesmo se o jogo for pausado
	music_bus_idx = AudioServer.get_bus_index("Music")
	lowpass_effect_idx = 0
	_setup_music_player()
	_setup_clock_player()

func set_music_opaque(opaque: bool) -> void:
	if music_bus_idx != -1:
		# Ativa ou desativa o efeito no canal Music
		AudioServer.set_bus_effect_enabled(music_bus_idx, lowpass_effect_idx, opaque)

func switch_to_win_music() -> void:
	# Se a música de vitória já estiver tocando, não faz nada
	if music_player.stream == WIN_MUSIC_2:
		return
		
	# 1. Faz o Fade Out da música atual diminuindo o volume do PLAYER (não do canal)
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(music_player, "volume_db", -80.0, 0.8) # -80dB é o mudo absoluto
	await tween.finished
	
	# 2. Troca o arquivo de áudio no meio da escuridão do som
	music_player.stop()
	
	if WIN_MUSIC_2 is AudioStreamMP3 or WIN_MUSIC_2 is AudioStreamOggVorbis:
		WIN_MUSIC_2.loop = true
		
	music_player.stream = WIN_MUSIC_2
	music_player.volume_db = 0.0 # Reseta o volume interno do player para o padrão
	music_player.play()
	
	# Desativa o filtro opaco caso ele estivesse ligado, para a vitória soar limpa e brilhante!
	set_music_opaque(false)

func reset_to_base_music() -> void:
	if music_player.stream == MUSIC_BASE:
		return
		
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(music_player, "volume_db", -80.0, 0.5)
	await tween.finished
	
	music_player.stop()
	music_player.stream = MUSIC_BASE
	music_player.volume_db = 0.0
	music_player.play()

func _setup_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	if MUSIC_BASE is AudioStreamMP3:
		MUSIC_BASE.loop = true
	elif MUSIC_BASE is AudioStreamOggVorbis:
		MUSIC_BASE.loop = true
		
	music_player.stream = MUSIC_BASE
	play_music()


func _setup_clock_player() -> void:
	clock_player = AudioStreamPlayer.new()
	clock_player.bus = "SFX"
	
	# Configura o áudio para rodar em Loop caso o tempo da dica seja muito longo
	if CLOCK_COUNTING_SFX is AudioStreamMP3 or CLOCK_COUNTING_SFX is AudioStreamOggVorbis:
		CLOCK_COUNTING_SFX.loop = true
		
	clock_player.stream = CLOCK_COUNTING_SFX
	add_child(clock_player)


func play_music() -> void:
	if not music_player.playing:
		music_player.play()

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

func _play_sfx(stream: AudioStream) -> void:
	if stream == null: 
		return
	
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.bus = "SFX"
	
	add_child(fx_player)
	fx_player.play()
	
	fx_player.finished.connect(func(): fx_player.queue_free())

func play_alarm() -> void:
	_play_sfx(ALARM_SFX)

func start_clock_counting() -> void:
	if not clock_player.playing:
		clock_player.play()

func stop_clock_counting() -> void:
	if clock_player.playing:
		clock_player.stop()

func play_random_card() -> void:
	_play_sfx(RANDOM_CARD_SFX)

func play_card_open() -> void:
	_play_sfx(CARD_OPEN_SFX)

func play_card_close() -> void:
	_play_sfx(CARD_CLOSE_SFX)

func play_card_turn() -> void:
	_play_sfx(CARD_TURN_SFX)

func play_card_slide(forward: bool) -> void:
	if forward:
		_play_sfx(CARD_SLIDE_NEXT_SFX)
	else:
		_play_sfx(CARD_SLIDE_PREVIOUS_SFX)

func play_correct(is_correct : bool) -> void :
	if is_correct :
		_play_sfx(CORRECT)
	else :
		_play_sfx(INCORRECT)

func play_pop_up() -> void :
	_play_sfx(POP_UP)
# PQ TOCA DOIS POP UP NA TELA DE WIN NO COMECO
func play_slide_pop_up() -> void :
	_play_sfx(SLIDEPOP)

func play_confetti() -> void :
	_play_sfx(CONFETTI)

func play_button() -> void :
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randf_range(1, 2)
	if my_random_number == 1 :
		_play_sfx(SWITCH_004)
	else :
		_play_sfx(SWITCH_005)

func update_volume_music(volume_linear: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		# Converte de 0.0 (mudo) a 1.0 (máximo) para a escala de decibéis correta
		var db = linear_to_db(volume_linear)
		AudioServer.set_bus_volume_db(bus_index, db)
		AudioServer.set_bus_mute(bus_index, volume_linear == 0.0)

func update_volume_sfx(volume_linear: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		var db = linear_to_db(volume_linear)
		AudioServer.set_bus_volume_db(bus_index, db)
		AudioServer.set_bus_mute(bus_index, volume_linear == 0.0)
