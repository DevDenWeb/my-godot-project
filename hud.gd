extends CanvasLayer

# Уведомляет узел `Main` о нажатии кнопки
signal start_game

# Временно отображает сообщение
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# Вызывается когда игрок проигрывает
func show_game_over():
	show_message("Игра окончена")
	# Подождите, пока MessageTimer не завершит обратный отсчет.
	await $MessageTimer.timeout
	
	$Message.text = "Увернись от Крипов!"
	$Message.show()
	# Заведите таймер на один заход и дождитесь его окончания.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
