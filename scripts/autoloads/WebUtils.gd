extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# "Are you sure you want to leave this page?" prompt
	JavaScriptBridge.eval(prevent_leaving_js)

const prevent_leaving_js : String = \
'window.addEventListener("beforeunload", function (event) {
    event.preventDefault();
    event.returnValue = true;
});
'
