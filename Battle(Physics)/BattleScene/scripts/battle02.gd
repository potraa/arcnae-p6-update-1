class_name Battle02 extends CanvasLayer

var questions = [
	{
		"question": "Totoy and a mob are both in the origin. The mob dashes 3m east then 4m north. What is the distance of the shortest route that Totoy should take in order to attack the mob?",
		"options": ["20m", "5m", "4m", "10m"],
		"correct_index": 1
	},
	{
		"question": "The second mob is more shifty and dashes 9m west then 12m south. What is the distance of the shortest route that Totoy should take in order to attack this mob?",
		"options": ["14m", "13m", "15m", "16m"],
		"correct_index": 2
	},
	{
		"question": "Totoy plans to throw a sharp stick towards a mob to hit it. The wind is blowing west at 8.0 m/s. Totoy wants the stick to have a resultant velocity of 17 m/s directed due north. What should be the velocity at which Totoy throws the stick to achieve this?",
		"options": ["15 m/s", "12 m/s", "14 m/s", "18 m/s"],
		"correct_index": 0
	},
	{
		"question": "After determining the velocity of the stick, what is the angle of the stick's velocity relative to due north? (Choose the angle that ensures the stick’s resultant motion is due north despite the wind blowing west.)",
		"options": ["28.1 degrees W of N", "28.1 degrees N of W", "27.6 W of N", "27.6 N of W"],
		"correct_index": 0
	},
	{
		"question": "The 3 remaining mobs try to escape through a wagon moving with a velocity of 63.5 m/s at 32 degrees south of east. Calculate the wagon’s horizontal and vertical velocity components.",
		"options": ["54.5 m/s, E & 33.64/2, S ", "53.85 m/s, E & 33.64 m/s, S", "33.60 m/s E", "53.85 m/s, E & 33.64 m/s, E"],
		"correct_index": 1
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
		question_label.text = "Chase after the remaining goblins! You can go down to see a surprise!"
	await get_tree().create_timer(2.0).timeout
	queue_free()
