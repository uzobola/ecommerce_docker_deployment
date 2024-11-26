#Choose an API from RapidAPI that interests you—make sure it has a free tier and simple authentication. 
# Write a Python script that makes a request to your selected API, using the appropriate endpoint and parameters to retrieve data. 
# Save the response data to a variable, and handle it as JSON to work with nested structures. 
# Extract a specific item from the nested dictionary in the response, and 
# print a statement that meaningfully displays this information. 


import requests
import json


# API from RapidAPI
# openweather API

# Endpoint that data would be retrieved from
url = "https://open-weather13.p.rapidapi.com/city/Nashville/EN"


# Security: API keys and host
headers = {
	"x-rapidapi-key": "253d1bf891mshcbd5624ec8e8861p1e2923jsn9a66729f68d9",
	"x-rapidapi-host": "open-weather13.p.rapidapi.com"
}

# Create variable to refrerence the parameters of the .get() above
response = requests.get(url, headers=headers)


# Collect JSON response into a variable for easier parsing
weather = response.json()

# Print the entire weather data, parse and indent for better readability
print(" Printing Full Weather Details:")
print(json.dumps(weather, indent=2))


# Collect weather data into variables and extract specific items to print meaningful statements
city_name = weather['name']
temperature = weather['main']['temp']
feels_like = weather['main']['feels_like']
humidity = weather['main']['humidity']
cloudiness = weather['clouds']['all']
visibility = weather['visibility']
print(f"The weather today in {city_name} is {temperature}°F . It feels like {feels_like} and the humidity level is {humidity}%")
print(f"The cloudiness percentage is {cloudiness}, and visibility score is {visibility} meters")