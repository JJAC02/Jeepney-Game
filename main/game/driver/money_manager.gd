extends Node
#Environment
const discount := 0.8
var passenger_fare:= 15 #placeholder for int from actual passenger
var driver_change := 0 #the amount to change when adding or subtracting
var total_driver_money := GameManager.money #GameManager.money for total dirver money


#Passenger/Commuter-Based
var commuter_paid := 40 # 40 placeholder for testing
var commuter_type := 'Regular'
var commuter_actual_fare:= 0
var commuter_change := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_commuter_details()
	calculate_change()
	display_change()

#General Functions
func calculate_change():
	#hidden function for checking if right change is given to passenger
	if commuter_type == 'Regular':
		commuter_actual_fare = passenger_fare * discount
	else:
		commuter_actual_fare = passenger_fare
	print(commuter_actual_fare);
	commuter_change = commuter_paid - passenger_fare
	print(commuter_change)

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
	pass

func display_commuter_details() -> void:
	var available_discount:int = round((1 - discount) * 100)
	$display_total_d_money.text = "Total DM: " + str(total_driver_money)
	$commuter_paid_display.text = "Commuter Gave: " + str(total_driver_money)
	$commuter_type_display.text = "Type: " + str(total_driver_money)
	$discount_details.text = "Students, Senior Citizens, and PWDs\n can avail a " + str(available_discount) + "%"

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

func _on_min_1_peso_pressed() -> void:
	subtract_change_value(1)

func _on_min_5_peso_pressed() -> void:
	subtract_change_value(5)

func _on_min_10_peso_pressed() -> void:
	subtract_change_value(10)

func _on_min_20_peso_pressed() -> void:
	subtract_change_value(20)

func _on_min_50_peso_pressed() -> void:
	subtract_change_value(50)

func _on_confirm_pressed() -> void:
	if driver_change == commuter_change:
		print("correct")
	else:
		print("wrong change") #still need to add the punishment code
	#once confirmed noew details will be added of the newly passed passenger details
	total_driver_money -= driver_change  #revisit for Node
	display_commuter_details()
	calculate_change()
	display_change()

	
func _on_clear_pressed() -> void:
	driver_change = 0
	display_change()
