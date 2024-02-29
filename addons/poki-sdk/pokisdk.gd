extends Node

var sdk_handle: JavaScriptObject
var _cb_commercial_break: JavaScriptObject
var _cb_reward_break: JavaScriptObject
var _cb_shareable_url: JavaScriptObject

signal commercial_break_done(response)
signal rewarded_break_done(response)
signal shareable_url_ready(url)

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web") == false:
		print("No JavaScript singleton detected")
		return
		
	sdk_handle = JavaScriptBridge.get_interface("PokiSDK")
	_cb_commercial_break = JavaScriptBridge.create_callback(on_commercial_break)
	_cb_reward_break = JavaScriptBridge.create_callback(on_reward_break)
	_cb_shareable_url = JavaScriptBridge.create_callback(on_shareable_url)

func gameplay_start():
	if not sdk_handle:
		print("Poki SDK Not Detected")
		return
	sdk_handle.gameplayStart()
	
func gameplay_stop():
	if not sdk_handle:
		print("Poki SDK Not Detected")
		return
	sdk_handle.gameplayStop()
	
func commercial_break():
	if not sdk_handle:
		print("Poki SDK Not Detected")
		return
	sdk_handle.commercialBreak().then(_cb_commercial_break)
	
func on_commercial_break(args):
	print("Commercial break done!")
	commercial_break_done.emit(args[0])

func rewarded_break():
	if not sdk_handle:
		print("Poki SDK Not Detected")
		return
	sdk_handle.rewardedBreak().then(_cb_reward_break)
	
func on_reward_break(args):
	print("Reward break done!")
	rewarded_break_done.emit(args[0])
	
func shareable_url(obj: Dictionary):
	if not sdk_handle:
		return
	var params = JavaScriptBridge.create_object("Object")
	
	for key in obj.keys():
		params[key] = obj[key]
	sdk_handle.shareableURL(params).then(_cb_shareable_url)

func on_shareable_url(url):
	shareable_url_ready.emit(url[0])
	
func is_ad_blocked():
	var ret = sdk_handle.isAdBlocked()
	return ret
	
func enable_event_tracking():
	if not sdk_handle:
		return
	sdk_handle.enableEventTracking()
