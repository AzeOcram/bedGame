extends CanvasLayer
#Handles UI  Methods: StartTimer, StartProgressBar, and DecreaseProgressBar

# Attributes
@onready var progressBar = $ProgressBar
@onready var timeLabel = $Label

var timer_running = false
var progress_running = false
var hours = [ "9 PM", "10 PM", "11 PM", "12 AM",
		"1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM"]

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func startTimer(duration: float) -> void:
	#a function to start the clock
	if timer_running:
		return
	timer_running = true
	
	var num_hours = hours.size()
	var interval = duration / num_hours # seconds per "hour"
	var elapsed = 0.0
	var hour_index = 0
	
	timeLabel.text = hours[hour_index]
	
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		
		# Check if we should increment hour
		var new_index = int(elapsed / interval)
		if new_index != hour_index and new_index < num_hours:
			hour_index = new_index
			timeLabel.text = hours[hour_index]
	
	# ensure it ends at last hour
	timeLabel.text = hours[num_hours - 1]
	timer_running = false

func decreaseProgress(amount: float) -> void:
	progressBar.value -= amount
	if progressBar.value < 0:
		progressBar.value = 0

func startProgressBar(rate: float) -> void:
	if progress_running:
		return
	progress_running = true
	while progressBar.value < progressBar.max_value:
		await get_tree().process_frame
		progressBar.value += rate * get_process_delta_time()
		if progressBar.value > progressBar.max_value:
			progressBar.value = progressBar.max_value
	progress_running = false
