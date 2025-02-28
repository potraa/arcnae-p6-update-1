class_name Battle05 extends CanvasLayer

var questions = [
	{
		"question": "Totoy and Lander are in an endurance competition. Totoy runs at a constant speed of 10 m/s for 12 minutes without stopping. How far does he travel during the competition? Assuming that Lander reached 7 km, does Tototy win the match? ",
		"options": ["Yes, because Totoy travelled 9.5km", "No, because Totoy travelled 5 km", "Yes, because Totoy travelled 7.2 km", "No, because Totoy travelled 6.3 km"],
		"correct_index": 2
	}
]

var current_question_index = 0
var player_health = 3

@onready var question_label: RichTextLabel = $Control/PanelContainer/RichTextLabel
@onready var choices_container: Control = $Control/Choices/Control

func _ready():
	for i in range(4):
		var button = choices_container.get_child(i) as Button
		if button:
			button.mouse_filter = Control.MOUSE_FILTER_STOP
			button.pressed.connect(func(): on_answer_selected(i))
	load_question()

func load_question():
	if current_question_index >= questions.size():
		end_quiz()
		return
	
	var current_question = questions[current_question_index]
	if question_label:
		question_label.text = current_question["question"]
	
	var options = current_question["options"]
	for i in range(4):
		var button = choices_container.get_child(i)
		if button:
			button.text = options[i] if i < options.size() else ""
			button.visible = i < options.size()

func on_answer_selected(index: int):
	var current_question = questions[current_question_index]
	if current_question["correct_index"] == index:
		current_question_index += 1
		load_question()
	else:
		player_health -= 1
		if player_health <= 0:
			game_over()

func game_over():
	if question_label:
		question_label.text = "Review more"
	await get_tree().create_timer(2.0).timeout
	queue_free()

func end_quiz():
	if question_label:
		question_label.text = "Successful delivery!"
	await get_tree().create_timer(2.0).timeout
	queue_free()
