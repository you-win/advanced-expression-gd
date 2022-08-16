extends CanvasLayer

func _ready() -> void:
	var ae = preload("res://addons/advanced-expression/advanced_expression.gd").new()
	
	ae.add_variable("text: String", "\"hello\"")
	ae.add_function("out").add_param("text").add("print(text + \" inside func\")")
	
	ae.add_param("input: String") \
		.add("out(input)") \
		.add("out(text)")
	
	if ae.compile() != OK:
		return
	
	ae.execute(["asdf"])
