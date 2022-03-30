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
	assert_null(ae.runner)
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

func test_full():
	pass
