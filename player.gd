extends Area2D
signal hit

@export var speed = 400
var screen_size

var target_position: Vector2
var is_touching: bool = false

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = global_position
	screen_size = get_viewport_rect().size
	hide()

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_touching = true
			target_position = event.position
		else:
			is_touching = false
	elif event is InputEventScreenDrag:
		target_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if is_touching:
		var direction = (target_position - global_position).normalized()
		if global_position.distance_to(target_position) > 5.0:
			global_position += direction * speed * delta
