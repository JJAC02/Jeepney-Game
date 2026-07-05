extends Node

#signals
signal hide_money_manager

#Environment
var passenger_fare:= 15 #placeholder for int from actual passenger
var driver_change := 0 #the amount to change when adding or subtracting
var total_driver_money := GameManager.money #GameManager.money for total driver money
var stress_bar_ph = 0
var discount : String

#Passenger/Commuter-Based
var commuter_paid :int= 0
var commuter_actual_fare:= 0
var commuter_change := 0
var commuter_type : String

#metadata
var regular: bool
var instance: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.accommodate_fare.connect(display_commuter_details)
	display_init()
	#display_commuter_details()
	#calculate_change()
	#display_change()

#General Functions
func calculate_change():
	print("fare: ", commuter_actual_fare)
	commuter_change = commuter_paid - passenger_fare
	print("supposed change: ", commuter_change)

func value_Checker() -> void:
	if driver_change < 0:
		print("No negative money")
		driver_change = 0

func add_change_value(passedValue:int) -> void:
	driver_change += passedValue
	print(driver_change)
	display_change()

func subtract_change_value(passedValue:int) -> void:
	driver_change -= passedValue
	print(driver_change)
	value_Checker()
	display_change()

func display_change() -> void:
	$change_display.text = "Change: " + str(driver_change)

func display_init() -> void:
	$display_total_d_money.text = "Total DM: " + str(total_driver_money)
	$commuter_paid_display.text = "Commuter Gave: "
	$commuter_type_display.text = "Type: "
	$discount_details.text = "Fare: "
	$change_display.text = "Change: "


func display_commuter_details(amt: int, is_regular: bool, inst: Node2D) -> void:
	commuter_paid = amt
	regular = is_regular
	instance = inst
	total_driver_money += commuter_paid
	passenger_fare = 12 if !regular else 15
	$display_total_d_money.text = "Total DM: " + str(total_driver_money)
	$commuter_paid_display.text = "Commuter Gave: " + str(commuter_paid)
	commuter_type = "Regular" if GameManager.is_regular == true else "Discounted"
	$commuter_type_display.text = "Type: " + commuter_type
	$discount_details.text = "Fare: " + str(passenger_fare)
#Button Functions
func _on_add_1_peso_pressed() -> void:
	add_change_value(1)

func _on_add_5_peso_pressed() -> void:
	add_change_value(5)

func _on_add_10_peso_pressed() -> void:
	add_change_value(10)

func _on_add_20_peso_pressed() -> void:
	add_change_value(20)

func _on_add_50_peso_pressed() -> void:
	add_change_value(50)

func _on_confirm_pressed() -> void:
	calculate_change()
	display_change()
	if driver_change < commuter_change :
		print('kulang')
		stress_bar_ph += 1
		print(stress_bar_ph)
		
	elif driver_change > commuter_change:
		print("d ", driver_change, " c ", commuter_change)
		print("wrong change")
		print('you lose money') #implement code
		stress_bar_ph += 1
		print(stress_bar_ph)
		
	else:
		print("correct")
		
	instance.change_recv()
	total_driver_money -= driver_change  #revisit for Node
	#display_commuter_details()
	driver_change = 0
	display_init()
	
func _on_clear_pressed() -> void:
	driver_change = 0
	display_commuter_details(commuter_paid, regular, instance)

func _on_hide_pressed() -> void:
	hide_money_manager.emit()
