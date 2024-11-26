
#Create a date.py script that is a date simulator and does the following:
#Date Script
#User inputs who is on the date with them
#User inputs their budget for the date
#Print the restaurant menu (your group created this!) 
#User inputs their food/drink item choices from a restaurant menu list (for themselves and their date)
#Script tells the user how much money they have left after each order.
#At the end of the date user must agree to pay the bill and then their final budget is shown to them.
#Challenge: Based on all the user inputs, the script should decide whether the user will get a second date or not and tell the user the decision.


import time
import dateFuncs



# Begin  User Interaction
print("Welcome to KuraCafe")


# Ask for User's name
user_name = input("\nMay we have your name please: ")  # input() captures user input. It displays a prompt and waits for the user to type


#User inputs who is on the date with them
date_name = input("\nPlease enter who is on the date with you: ")


#User inputs their budget for the date
budget = float(input("\nPlease enter your Budget for this date: ")) # input() is converted to float since the data type is a float.


# Print  Restaurant Menu
print("\nPlease see our Menu Options... ")
time.sleep(2)
dateFuncs.print_menu(dateFuncs.kuraCafe) 
time.sleep(3)


# Place Order
#User inputs their food/drink item choices from a restaurant menu list (for themselves and their date)
place_order = input("\nAre you ready to place your order? Enter Y or N ")
if place_order == "Y":
   print("\n Please, place your order")
   
  # Create a list from the kuraCafe menu list
  menu_items = [item for menu_section in dateFuncs.kuraCafe.values() for item in menu_section]
  
  # Variables to collect order
  date_order = input("\n What would your date like to have?")
  user_order = input("\n What would you like to have?")

  #Variables to get prices
  date_order_price = dateFuncs.get_price(date_order, dateFuncs.kuraCafe)
  user_order_price = dateFuncs.get_price(user_order, dateFuncs.kuraCafe)
  total_order_cost = date_order_price + user_order_price
  leftover_budget = budget - total_order_cost
  
  # Make sure they enter items in the menu list
  if date_order in menu_items and user_order in menu_items:
        print(f"\nYou have ordered {date_order} for your date and {user_order} for yourself.")
        print(f"Total order cost: ${total_order_cost}")
        print(f"Remaining budget: ${leftover_budget}")  
	
     # Confirm payment
        confirm_payment = input("\nDo you agree to pay the bill? Enter Y or N: ")
        if confirm_payment == "Y":
            print("\nThank you, enjoy your meal.")
        else:
            print("\nNo problems, please come back later.")


  else:
        if date_order not in menu_items:
            print(f"\n'{date_order}' is not on our menu.")
        if user_order not in menu_items:
            print(f"\n'{user_order}' is not on our menu.")
        print("\nPlease check the menu and try again.")

else:
   print("\n No rush, you can come back when you are ready")


time.sleep(3)





