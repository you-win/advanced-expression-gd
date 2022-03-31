extends "res://tests/base_test.gd"

# https://github.com/bitwes/Gut/wiki/Quick-Start

###############################################################################
# Builtin functions                                                           #
###############################################################################

func before_all():
	pass

func before_each():
	ae = AdvancedExpression.new()

func after_each():
	pass

func after_all():
	pass

###############################################################################
# Utils                                                                       #
###############################################################################

###############################################################################
# Tests                                                                       #
###############################################################################

var ae: AdvancedExpression

func test_add_raw():
	ae.add_raw("var i: int = 1;return i")
	assert_ok(ae.compile())
	assert_eq(ae.execute(), 1)
	
	ae.clear()
	
	assert_true(ae.variables.empty())
	assert_true(ae.functions.empty())
	assert_eq(ae.runner._cache.size(), 1)
	assert_null(ae.gdscript)
	
	ae.add_raw("var count: int = 0;for i in 5:;\tcount += 1;return count")
	assert_ok(ae.compile())
	assert_eq(ae.execute(), 5)
	
	ae.clear()
	
	ae.add_raw("""
		var count: int = 0
		for i in 5:
			count += 1
		return count
	""")
	assert_ok(ae.compile())
	assert_eq(ae.execute(), 5)
	
	ae.clear()
	
	ae.add_raw("""
		var builder := PoolStringArray()
		builder.append("hello")
		builder.append(" ")
		builder.append("world")
		
		var res := builder.join("")
		
		return res
	""")
	assert_ok(ae.compile())
	assert_eq(ae.execute(), "hello world")
	
	ae.clear()
	
	ae.add_raw("return null")
	assert_ok(ae.compile())
	assert_null(ae.execute())
	
	ae.clear()
	
	ae.add_raw("pass")
	assert_ok(ae.compile())
	assert_null(ae.execute())

func test_simple_counter():
	ae.add_variable("counter: int", "0")
	ae.add_function("add") \
		.add_param("input: int") \
		.add("return input + 1")
	
	ae.add("for i in 5:")
	ae.tab()
	ae.add("counter = add(counter)")
	ae.add("return counter")
	
	assert_ok(ae.compile())
	assert_eq(ae.execute(), 5)

func test_counter_with_input():
	ae.add_variable("counter").add(0)
	
	ae.add_function("increment") \
		.add_param("input: int") \
		.add("return input + 1")
	
	ae.add() \
		.add_param("starting_value") \
		.add("counter = starting_value") \
		.add("for i in 5:") \
		.tab().add("counter = increment(counter)") \
		.add("return counter")
	
	assert_ok(ae.compile())
	assert_eq(ae.execute([1]), 6)

func test_inputs():
	ae.add_variable("template").add("\"Hello, %s\"")
	
	ae.add_function("insert_text").add_param("input").add("return template % input")
	
	ae.add("var replaced_text = insert_text(some_input)") \
		.add("return replaced_text") \
		.add_param("some_input: String")
	
	assert_ok(ae.compile())
	assert_eq(ae.execute(["world"]), "Hello, world")
