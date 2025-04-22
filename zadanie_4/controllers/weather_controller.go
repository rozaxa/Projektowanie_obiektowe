package controllers

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"zadanie_4/models"

	"github.com/labstack/echo/v4"
)

func GetWeather(c echo.Context) error {
	city := c.QueryParam("city")
	if city == "" {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "City name is required"})
	}

	geoURL := fmt.Sprintf("https://geocoding-api.open-meteo.com/v1/search?name=%s", city)
	req, err := http.NewRequest("GET", geoURL, nil)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to create geo request"})
	}
	req.Header.Set("User-Agent", "Go-Echo-WeatherApp")

	client := &http.Client{}
	geoResp, err := client.Do(req)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to geocode city"})
	}
	defer geoResp.Body.Close()

	body, err := ioutil.ReadAll(geoResp.Body)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to read geocode response"})
	}

	var geo models.GeoResponse
	if err := json.Unmarshal(body, &geo); err != nil || len(geo.Results) == 0 {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "Could not find location"})
	}

	lat := geo.Results[0].Latitude
	lon := geo.Results[0].Longitude

	weatherURL := fmt.Sprintf("https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current_weather=true", lat, lon)
	weatherResp, err := http.Get(weatherURL)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to fetch weather data"})
	}
	defer weatherResp.Body.Close()

	weatherBody, err := ioutil.ReadAll(weatherResp.Body)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to read weather response"})
	}

	var weather models.WeatherResponse
	if err := json.Unmarshal(weatherBody, &weather); err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to parse weather response"})
	}

	simpleWeather := models.SimpleWeather{
		City:        city,
		Temperature: weather.CurrentWeather.Temperature,
		Windspeed:   weather.CurrentWeather.Windspeed,
	}

	return c.JSON(http.StatusOK, simpleWeather)
}
