extends Node
## Global calculation state. Buttons send input here; the UI listens for changes.

signal display_changed(value: String)

var display_value: String = "0"
var _stored_value: float = 0.0
var _pending_symbol: String = ""
var _start_new_number: bool = true
var _has_error: bool = false


func enter_number(number: String) -> void:
	if number not in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]:
		return
	if _has_error:
		clear()
	var next_value := display_value
	if _start_new_number:
		next_value = "0"
		_start_new_number = false
	if number == ".":
		if "." in next_value:
			return
		next_value += "."
	elif next_value == "0":
		next_value = number
	elif next_value.length() < 14:
		next_value += number
	_set_display(next_value)


func enter_symbol(symbol: String) -> void:
	if _has_error or symbol not in ["+", "-", "*", "/"]:
		return
	# Evaluate chains from left to right, as a basic handheld calculator does.
	if _pending_symbol != "" and not _start_new_number:
		evaluate()
		if _has_error:
			return
	_stored_value = display_value.to_float()
	_pending_symbol = symbol
	_start_new_number = true


func evaluate() -> void:
	if _has_error or _pending_symbol == "" or _start_new_number:
		return
	var right_value := display_value.to_float()
	var result := _stored_value
	match _pending_symbol:
		"+": result += right_value
		"-": result -= right_value
		"*": result *= right_value
		"/":
			if right_value == 0.0:
				_show_error()
				return
			result /= right_value
	if not is_finite(result):
		_show_error()
		return
	_pending_symbol = ""
	_start_new_number = true
	_set_display(String.num(result, 10).trim_suffix(".0"))


func clear() -> void:
	_stored_value = 0.0
	_pending_symbol = ""
	_start_new_number = true
	_has_error = false
	_set_display("0")


func _show_error() -> void:
	_pending_symbol = ""
	_start_new_number = true
	_has_error = true
	_set_display("Error")


func _set_display(value: String) -> void:
	display_value = value
	display_changed.emit(display_value)
