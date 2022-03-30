extends Reference

class AbstractCode:
	var _cache := []
	
	func _to_string() -> String:
		return "%s\n%s" % [_get_name(), output()]
	
	func _get_name() -> String:
		return "AbstractCode"
	
	static func _build_string(list: Array) -> String:
		return PoolStringArray(list).join("")
	
	func tab(times: int = 1) -> AbstractCode:
		for i in times:
			_cache.append("\t")
		return self
	
	func newline() -> AbstractCode:
		_cache.append("\n")
		return self
	
	func add(text) -> AbstractCode:
		match typeof(text):
			TYPE_STRING:
				tab()
				_cache.append(text)
				newline()
			TYPE_ARRAY:
				_cache.append_array(text)
			_:
				push_error("Invalid parameter for add(text) - %s" % str(text))
		
		return self
	
	func clear_cache() -> AbstractCode:
		_cache.clear()
		return self
	
	#endregion
	
	#region Finish
	
	func output() -> String:
		return _build_string(_cache)
	
	func raw_data() -> Array:
		return _cache
	
	#region

class Variable extends AbstractCode:
	func _init(var_name: String, var_value: String = "") -> void:
		_cache.append("var %s = " % var_name)
		if not var_value.empty():
			_cache.append(var_value)
	
	func _get_name() -> String:
		return "Variable"
	
	func add(text) -> AbstractCode:
		if typeof(text) != TYPE_STRING:
			push_error("Only Strings can be added to a %s - %s" % [_get_name(), str(text)])
			return self
		
		_cache.append(text)
		
		return self

class Function extends AbstractCode:
	var _function_def := ""
	var _params := []
	
	func _init(text: String) -> void:
		_function_def = "func %s%s:" % [text, "%s"]
		# Always add a newline into the cache
		newline()
	
	func _get_name() -> String:
		return "Function"
	
	func _construct_params() -> String:
		var params := []
		params.append("(")
		
		for i in _params:
			params.append(i)
			params.append(",")
		
		# Remove the last comma
		if params.size() > 1:
			params.pop_back()
		
		params.append(")")
		return PoolStringArray(params).join("")
	
	func add_param(text: String) -> AbstractCode:
		if _params.has(text):
			push_error("Tried to add duplicate param")
		else:
			_params.append(text)
		return self
	
	func output() -> String:
		return "%s%s" % [_function_def % _construct_params(), _build_string(_cache)]

class Runner extends AbstractCode:
	func _init() -> void:
		_cache.append("func %s():" % RUN_FUNC)
		newline()
	
	func _get_name() -> String:
		return "Runner"

const RUN_FUNC := "__runner__"

var variables := []
var functions := []
var runner: Runner

var gdscript: GDScript

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

static func _create_script(v: Array, f: Array, r: Runner) -> GDScript:
	var s := GDScript.new()
	
	var source := ""
	
	for i in v:
		source += i.output()
	
	for i in f:
		source += i.output()
	
	source += r.output()
	
	s.source_code = source
	
	return s

###############################################################################
# Public functions                                                            #
###############################################################################

func add_variable(variable_name: String, variable_value: String = "") -> Variable:
	var variable := Variable.new(variable_name, variable_value)
	
	variables.append(variable)
	
	return variable

func add_function(function_name: String) -> Function:
	var function := Function.new(function_name)
	
	functions.append(function)
	
	return function

func add() -> Runner:
	runner = Runner.new()
	
	return runner

func add_raw(text: String) -> Runner:
	runner = Runner.new()
	
	var split := text.split(";")
	for i in split:
		runner.add(i)
		runner.newline()
	
	return runner

func compile() -> int:
	gdscript = _create_script(variables, functions, runner)
	
	return gdscript.reload()

func execute():
	return gdscript.new().call(RUN_FUNC)

func clear() -> void:
	gdscript = null
	
	variables.clear()
	functions.clear()
	runner = null
