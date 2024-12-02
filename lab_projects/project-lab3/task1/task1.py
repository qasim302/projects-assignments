import re

# Define the regular expression pattern for the order ID
pattern = r"^20[0-9]{2}-[a-z]{6}-[0-9]{6}-(A|B)[0-9]$"
order_id_regex = re.compile(pattern)

# Function to validate the order ID
def validate_order_id(order_id):
    if order_id_regex.match(order_id):
        return True
    else:
        return False

# Main program to interact with the customer
def main():
    # Prompt the user to enter their order ID
    order_id = input("Please enter your order ID (format: YYYY-CUSTID-NUMBER-CH): ")
    
    # Validate the order ID and provide feedback
    if validate_order_id(order_id):
        print("Your order ID is valid.")
    else:
        print("Invalid order ID. Please check the format and try again.")

# Run the main function if this script is executed directly
if __name__ == "__main__":
    main()
