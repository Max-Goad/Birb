extends Label

### Variables
@export var damage : int = 100
@export_range(0.5, 2.0) var speed : float = 1.0

var color : Color = Color.WHITE
@onready var alpha_countdown: Timer = $Alpha
@onready var free_countdown: Timer = $Free
var reduce_alpha : bool = false

### Signals
signal complete

### Engine Functions
func _ready() -> void:
	self.text = str(damage)
	self.add_theme_color_override("font_color", color)

	alpha_countdown.one_shot = true
	alpha_countdown.timeout.connect(_on_alpha_timer)

	free_countdown.one_shot = true
	free_countdown.timeout.connect(_on_free_timer)

	alpha_countdown.start(0.25 / speed)

func _process(delta: float) -> void:
	position.y -= speed * 2 * delta * 100
	if reduce_alpha:
		color.a -= speed / 10
		self.modulate = color

### Public Functions

### Private Functions
func _on_alpha_timer():
	reduce_alpha = true
	free_countdown.start(0.25 / speed)

func _on_free_timer():
	complete.emit()
	queue_free()
