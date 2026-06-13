extends Button

signal tip_finished

var old_text: String
var tip_text: String
var used: bool = false

var progress_bar_colours = {  
	"GREEN" : "#44C155",
	"ORANGE" : "#E89521",
	"RED" : "#E82121"
}

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: RichTextLabel = $MarginContainer/Label
@onready var tip_bg: Button = $"."
@onready var timer: Timer = $Timer

func _ready() -> void:
	progress_bar.hide()
	progress_bar.value = 100
	set_process(false)
	tip_finished.connect(SessionState._on_tip_used)


func _process(_delta: float) -> void:
	var current_left_time_value = (timer.time_left / timer.wait_time) * 100
	progress_bar.value = current_left_time_value
	if(current_left_time_value <= 20):
		set_color_progress_bar(progress_bar_colours.RED)
	elif(current_left_time_value <= 50):
		set_color_progress_bar(progress_bar_colours.ORANGE)
	else:
		set_color_progress_bar(progress_bar_colours.GREEN)
		
func start_tip():
	disabled = true
	used = true

	tip_bg.modulate = "#c6c6c6";

	progress_bar.value = 100
	progress_bar.show()
	
	timer.start()
	set_process(true)

func _on_timer_timeout() -> void:
	set_process(false)
	label.text = "[s]%s[/s]" % [old_text]
	tip_finished.emit()
	
	
func set_tip_text(text_for_tip: String):
	old_text = text_for_tip
	tip_text = text_for_tip
	label.text = tip_text

func set_color_progress_bar(new_color : Color) -> void:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = new_color
	progress_bar.add_theme_stylebox_override("fill", stylebox)
