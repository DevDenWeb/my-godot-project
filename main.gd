extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Приготовтесь")

func _on_mob_timer_timeout():
	
	# Создание нового экземпляра Mob scene
	var mob = mob_scene.instantiate()
	
	# Выбирает случайное место на Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Устанавливает направление моба перпендикулярно направлению пути
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Устанавливает позицию моба в случайном месте
	mob.position = mob_spawn_location.position
	
	# Добавляет случайное направление
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Выбирает скорость для моба
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Создаёт моба, доавив его на Main scene
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
