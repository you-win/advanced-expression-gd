extends "res://tests/base_test.gd"

# https://github.com/bitwes/Gut/wiki/Quick-Start

###############################################################################
# Builtin functions                                                           #
###############################################################################

func before_all():
	pass

func before_each():
	pass

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

func test_variable_add():
	var variable_1 = AdvancedExpression.Variable.new("my_var")
	
	variable_1.add("1")
	
	var output_1: String = variable_1.output()
	assert_false(output_1.empty())
	
	var expected_1 := """
		var my_var = 1
	""".strip_edges()
	
	assert_eq(output_1.strip_edges(), expected_1)
	
	var variable_2 = AdvancedExpression.Variable.new("my_var_2", "2")
	
	var output_2: String = variable_2.output()
	assert_false(output_2.empty())
	
	var expected_2 := """
		var my_var_2 = 2
	""".strip_edges()
	
	assert_eq(output_2.strip_edges(), expected_2)
	
	var variable_3 = AdvancedExpression.Variable.new("my_var_3")
	
	variable_3 \
		.add("PoolStringArray(").newline() \
			.tab().add("['hello ', 'world'])")
	
	var output_3: String = variable_3.output()
	assert_false(output_3.empty())
	
	var expected_3 := """
var my_var_3 = PoolStringArray(
	['hello ', 'world'])
	""".strip_edges()
	
	assert_eq(output_3.strip_edges(), expected_3)
	
	print(output_3.strip_edges())
	print(expected_3)

func test_variable_name():
	var variable = AdvancedExpression.Variable.new("my_variable")
	
	assert_eq(variable._get_name(), "Variable")

func test_variable_to_string():
	var variable = AdvancedExpression.Variable.new("my_variable")
	
	variable.add("1")
	
	var expected := """
Variable
var my_variable = 1
	""".strip_edges()
	
	assert_eq(variable.to_string().strip_edges(), expected)
	
	var variable_2 = AdvancedExpression.Variable.new("my_variable_2", "2")
	
	var expected_2 := """
Variable
var my_variable_2 = 2
	""".strip_edges()
	
	assert_eq(variable_2.to_string().strip_edges(), expected_2)
