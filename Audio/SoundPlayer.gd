extends Node

const ENERGY_PICKUP = preload("res://Audio/SFX/energy_pickup.wav")
const SMALL_LASER = preload("res://Audio/SFX/small_laser2.wav")
const ENEMY_DESTROYED = preload("res://Audio/SFX/enemy_destroyed.wav")
const CHARGE = preload("res://Audio/SFX/ChargeUpSFX.wav")
const CHARGESHOT = preload("res://Audio/SFX/charge_shot.wav")
const QUANTUMSHIFT = preload("res://Audio/SFX/quantum_shift.wav")
const SHIELDHIT = preload("res://Audio/SFX/ShieldHit.wav")
const BOSSDEATH = preload("res://Audio/SFX/BossDeath.wav")

onready var audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
