extends Node

const MAINTHEME: = preload("res://Audio/Music/NegativeSpaceTheme.wav")
const BOSSTHEME: = preload("res://Audio/Music/NegativeSpaceBoss.wav")
const VICTORY: = preload("res://Audio/Music/NegativeSpaceFanfare.wav")

onready var musicPlayer = $MusicPlayer

func play_song(song):
		musicPlayer.stream = song
		musicPlayer.play()
