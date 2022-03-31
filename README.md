# Advanced Expression GD
Functions like Godot's built-in `Expression` class with the flexability of an actual script.

See the `tests/` directory for more examples.

## Example
```GDScript
var ae = preload("res://addons/advanced-expression/advanced_expression.gd")

ae.add_variable("counter").add(0)

ae.add_function("increment") \
	.add_param("input: int") \
	.add("return input + 1")

ae.add() \
	.add_param("starting_value") \
	.add("counter = starting_value") \
	.add("for i in 5:") \
	.tab() \
	.add("counter = increment(counter)") \
	.add("return counter")

if ae.compile() != OK:
	push_error("Failed to compile")

assert(ae.execute([1]) == 6)
```

