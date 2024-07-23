class_name Textbox extends Control

### Variables
@onready var label: Label = $PanelContainer/HBoxContainer/TextContainer/Label
@onready var carat: Label = $PanelContainer/HBoxContainer/CaratContainer/Carat
@onready var timer: Timer= $Timer

@export_multiline var text: String
@export var settings: LabelSettings
@export var text_speed: float = 15.0
@export var cancellable: bool = true
@export var finished: bool = false

@export var timeout: float

var tween: Tween

### Signals
signal complete

### Public Functions
func start():
	print("Textbox: start")
	if text_speed > 0.0:
		label.visible_ratio = 0.0
		tween = create_tween()
		tween.tween_property(label, "visible_ratio", 1.0, label.text.length() / text_speed)
		tween.tween_callback(_display_carat)
		if timeout:
			tween.tween_callback(_start_despawn_timer)
	else:
		label.visible_ratio = 1.0
		_display_carat()
		if timeout:
			_start_despawn_timer()


func finish():
	if not finished:
		finished = true
		complete.emit()
		# TODO: Is this the best place to do this? Or should a queue handle this instead?
		queue_free()

### Engine Functions
func _ready():
	if text:
		label.text = text
		label.label_settings = settings
	timer.one_shot = true
	timer.timeout.connect(finish)
	if timeout:
		timer.wait_time = timeout
	carat.visible_ratio = 0.0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("Textbox: cancelled (keyboard)")
		finish()

func _gui_input(event: InputEvent) -> void:
	if cancellable and event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT] and event.is_released():
		print("Textbox: cancelled (mouse)")
		finish()

### Private Functions
func _display_carat():
	carat.visible_ratio = 1.0

func _start_despawn_timer():
	print("Textbox: start despawn timer")
	timer.start()
