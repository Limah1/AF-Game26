extends Node

var background_music = load("res://assets/sounds/sons editados/background_music_by_debora.wav")


func play_music() :
	$background_music.stream = background_music
	$background_music.play()


func stop_music():
	$background_music.stop()
