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

func test_runner_add():
	var runner = AdvancedExpression.Runner.new()
	
	runner \
		.add("var counter: int = 1") \
		.add("counter += 1") \
		.add("return counter")
	
	var output: String = runner.output()
	assert_false(output.empty())
	
	var expected := """
func __runner__():
	var counter: int = 1
	counter += 1
	return counter
	""".strip_edges()
	
	assert_eq(output.strip_edges(), expected)
	
	var ae = AdvancedExpression.new()
	ae.runner = runner
	
	assert_ok(ae.compile())
	assert_eq(ae.execute(), 2)

func test_runner_name():
	var runner = AdvancedExpression.Runner.new()
	
	assert_eq(runner._get_name(), "Runner")

func test_runner_to_string():
	var runner = AdvancedExpression.Runner.new()
	
	runner.add("return 1")
	
	var expected := """
Runner
func __runner__():
	return 1
	""".strip_edges()
	
	assert_eq(runner.to_string().strip_edges(), expected)
