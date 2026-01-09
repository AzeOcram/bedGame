extends CanvasLayer
#Handles UI Methods: StartTimer, StartProgressBar, and IncreaseProgressBar

# Signals to notify game manager
signal progress_complete
signal timer_complete

# Attributes
@onready var progressBar = $ProgressBar
@onready var timeLabel = $Label
var timer_running = false
var progress_running = false
var current_drain_rate = 2.0

var hours = [ "9 PM", "10 PM", "11 PM", "12 AM",
		"1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM"]

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
		# Check if node is still in tree
		if not is_inside_tree():
			timer_running = false
			return
			
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
	
	# Emit signal when timer completes
	timer_complete.emit()

func increaseProgress(amount: float) -> void:
	progressBar.value += amount
	if progressBar.value > progressBar.max_value:
		progressBar.value = progressBar.max_value
		
func decreaseProgress(amount: float) -> void:
	progressBar.value -= amount
	if progressBar.value < progressBar.min_value:
		progressBar.value = 0

func startProgressBar() -> void:
	if progress_running:
		return
	progress_running = true
	
	# Start from 0
	progressBar.value = 0
	
	while progressBar.value < progressBar.max_value:
		# Check if node is still in tree
		if not is_inside_tree():
			progress_running = false
			return
			
		await get_tree().process_frame
		# Progress increases over time
		progressBar.value += current_drain_rate * get_process_delta_time()
		if progressBar.value > progressBar.max_value:
			progressBar.value = progressBar.max_value
	
	progress_running = false
	
	# Emit signal when progress bar completes
	progress_complete.emit()

# Function to set fill rate based on flashlight state
func set_drain_rate(light_on: bool) -> void:
	if light_on:
		#current_drain_rate = 0.01  # Slower fill: 1% per second when light is ON
		current_drain_rate = 0.7
	else:
		#current_drain_rate = 0.05  # Faster fill: 2% per second when light is OFF
		current_drain_rate = 2.0
