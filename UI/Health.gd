extends Control

onready var healthBar = $HealthBar

func _ready():
	healthBar.value = 100

func set_value(value):
	healthBar.value = value
