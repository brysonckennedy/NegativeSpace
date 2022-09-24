extends KinematicBody2D

var velocityX = 0
var velocityY = 0
var terminalVelocity = 500
var accerleration = 20
var decerleration = 20

func _physics_process(delta):
	print(getDirection().x)
	
	#X Direction Movement
	if getDirection().x > 0:
		if velocityX < terminalVelocity:
			velocityX =  velocityX + (delta * 60 * accerleration) #multiply by action strength to have increase in acceleration with stick
	if getDirection().x < 0:
		if velocityX > -terminalVelocity:
			velocityX =  velocityX + (delta * 60 * -accerleration)
	#Deceleration X
	if getDirection().x == 0:
		if velocityX > 0:
			velocityX = velocityX + (delta * 60 * -decerleration)
		if velocityX < 0:
			velocityX = velocityX + (delta * 60 * decerleration)

	#Y Direction Movement
	if getDirection().y > 0:
		if velocityY < terminalVelocity:
			velocityY =  velocityY + (delta * 60 * accerleration)
	if getDirection().y < 0:
		if velocityY > -terminalVelocity:
			velocityY =  velocityY + (delta * 60 * -accerleration)
	#Deceleration Y
	if getDirection().y == 0:
		if velocityY > 0:
			velocityY = velocityY + (delta * 60 * -decerleration)
		if velocityY < 0:
			velocityY = velocityY + (delta * 60 * decerleration)
	
	
	
	if _magnitude(Vector2(velocityX, velocityY)) < terminalVelocity:
		move_and_slide(Vector2(velocityX, velocityY), Vector2.UP)
	else:
		move_and_slide(Vector2(velocityX, velocityY).normalized() * terminalVelocity, Vector2.UP)

func getDirection():
	var RightDirection = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
	var UpDirection = Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp") 
	var DirectionVector : Vector2 = Vector2(RightDirection, UpDirection)
	return DirectionVector

func _magnitude(v):
	return sqrt(pow(v.x, 2) + pow(v.y, 2))

func _normalize(v):
	return v / _magnitude(v)
