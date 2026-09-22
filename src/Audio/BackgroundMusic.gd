extends Node

var background_music = load("res://src/Assets/Audio/Music/home_theme.wav")


func play_music() :
	$background_music.stream = background_music
	$background_music.play()


func stop_music():
	$background_music.stop()
