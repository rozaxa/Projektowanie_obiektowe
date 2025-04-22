package models

type WeatherResponse struct {
	CurrentWeather struct {
		Temperature float64 `json:"temperature"`
		Windspeed   float64 `json:"windspeed"`
	} `json:"current_weather"`
}

type SimpleWeather struct {
	City        string  `json:"city"`
	Temperature float64 `json:"temperature"`
	Windspeed   float64 `json:"windspeed"`
}
