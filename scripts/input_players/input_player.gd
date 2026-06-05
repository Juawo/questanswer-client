@tool
extends VBoxContainer

signal text_changed(text : String)

@onready var label: Label = $Label
@onready var line_edit: LineEdit = $LineEdit
@onready var line_focus: ColorRect = $LineEdit/line_focus
@onready var detail: Label = $detail
var text : String
var detail_text : String

@export var is_disabled : bool = false :
	set(new_value) :
		is_disabled = new_value
		
		if not is_node_ready():
			await ready
			
		if is_disabled :
			modulate = Color(1.0, 1.0, 1.0, 0.502)
			label.add_theme_color_override("font_color", "#404040")
			line_edit.editable = false
			line_edit.text = ""
		else :
			modulate = Color(1.0, 1.0, 1.0, 1.0)
			label.add_theme_color_override("font_color", Color.BLACK)
			line_edit.editable = true

@export var title : String :
	set(new_value) :
		title = new_value
		if not is_node_ready():
			await ready
		label.text = new_value

func show_line_focus(is_focus : bool) -> void :
	line_focus.pivot_offset.x = line_edit.size.x / 2
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if is_focus :
		tween.tween_property(line_focus, "scale:x", 1, 0.3)
	else :
		tween.tween_property(line_focus, "scale:x", 0.0, 0.2)

func _on_line_edit_focus_entered() -> void:
	if is_disabled:
		return
	show_line_focus(true)

func _on_line_edit_focus_exited() -> void:
	show_line_focus(false)

func _on_line_edit_text_changed(new_text: String) -> void:
	text = new_text
	text_changed.emit()

func update_detail_text(new_text : String, color : Color) -> void :
	detail.text = new_text
	detail.add_theme_color_override("font_color", color)
