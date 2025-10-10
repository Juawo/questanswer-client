extends Button

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
@onready var panel_container: PanelContainer = $PanelContainer

func _ready() -> void:
	progress_bar.hide()
	progress_bar.value = 100

func _process(_delta: float) -> void:
	var current_value_progress_bar = progress_bar.value
	if(current_value_progress_bar <= 20):
		set_color_progress_bar(progress_bar_colours.RED)
	elif(current_value_progress_bar <= 50):
		set_color_progress_bar(progress_bar_colours.ORANGE)
	else:
		set_color_progress_bar(progress_bar_colours.GREEN)
		

func set_tip_text(text_for_tip: String):
	old_text = text_for_tip
	tip_text = text_for_tip
	label.text = tip_text

func set_color_progress_bar(new_color : Color) -> void:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = new_color
	progress_bar.add_theme_stylebox_override("fill", stylebox)

func _on_pressed() -> void:
	self.disabled = true
	self.used = true
	
	panel_container.modulate = "#c6c6c6";
	label.text = "[s]%s[/s]" % [old_text]
	
	progress_bar.value = 100
	progress_bar.show()
	
	var tween_bar = create_tween()
	tween_bar.tween_property(progress_bar, "value", 0, 15.0)
	#Adicionar signal para "avisar" que o tempo da dica terminou
	# E agora outra dica ja pode ser usada
	#Adicionar som de finish!
