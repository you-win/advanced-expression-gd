extends "res://addons/gut/test.gd"

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

func assert_ok(value) -> bool:
	assert_eq(value, OK)
	return value == OK

###############################################################################
# Tests                                                                       #
###############################################################################

const AdvancedExpression = preload("res://addons/advanced-expression/advanced_expression.gd")
