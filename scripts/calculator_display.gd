class_name CalculatorDisplay extends PanelContainer

## Reusable display: listens to the global calculator independently of its parent.
@onready var display: Label = $Display


func _ready() -> void:
	GlobalCalculator.display_changed.connect(update_display)
	update_display(GlobalCalculator.display_value)


func update_display(value: String) -> void:
	display.text = value
