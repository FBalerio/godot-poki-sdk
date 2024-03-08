extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	PokiSDK.commercial_break_done.connect(on_commercial_break_done)
	PokiSDK.rewarded_break_done.connect(on_reward_break_done)
	PokiSDK.shareable_url_ready.connect(on_shareable_url_ready)
	
	PokiSDK.gameplay_start()

	$Label3.text = str(PokiSDK.is_ad_blocked())
	
	$AudioStreamPlayer.play()

func on_reward_break_done(success):
	print("Reward response:", success)
	if success:
		$Label.text = "Reward gained!"
	else:
		$Label.text = "No Reward."
	PokiSDK.gameplay_start()
	#resume the game audio.
	$AudioStreamPlayer.stream_paused = false
	
func on_commercial_break_done(response):
	print("Commercial break done", response)
	PokiSDK.gameplay_start()
	#resume the game audio
	$AudioStreamPlayer.stream_paused = false

func on_shareable_url_ready(url):
	print("URL: ", url)
	$Label.text = url
	
func _on_Button_pressed():
	#pause any audio running in game. 
	$AudioStreamPlayer.stream_paused = true
	PokiSDK.gameplay_stop()
	PokiSDK.commercial_break()

func _on_Button2_pressed():
	PokiSDK.shareable_url({"a":1, "b":2})


func _on_Button3_pressed():
	#pause any audio running in game. 
	$AudioStreamPlayer.stream_paused = true
	PokiSDK.gameplay_stop()
	PokiSDK.rewarded_break()
