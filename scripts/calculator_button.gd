class_name CalculatorButton extends Button

## Each button translates its built-in pressed signal into a calculator signal.
signal number_pressed(number: String)
signal symbol_pressed(symbol: String)
signal equals_pressed
signal clear_pressed

enum InputType { NUMBER, SYMBOL, EQUALS, CLEAR }

@export var input_type: InputType = InputType.NUMBER
@export var value: String = ""


func _ready() -> void:
	number_pressed.connect(GlobalCalculator.enter_number)
	symbol_pressed.connect(GlobalCalculator.enter_symbol)
	equals_pressed.connect(GlobalCalculator.evaluate)
	clear_pressed.connect(GlobalCalculator.clear)
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	match input_type:
		InputType.NUMBER: number_pressed.emit(value)
		InputType.SYMBOL: symbol_pressed.emit(value)
		InputType.EQUALS: equals_pressed.emit()
		InputType.CLEAR: clear_pressed.emit()
