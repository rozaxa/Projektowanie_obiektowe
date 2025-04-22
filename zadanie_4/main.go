package main

import (
	"zadanie_4/controllers"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	e.GET("/weather", controllers.GetWeather)

	e.Logger.Fatal(e.Start(":8080"))
}
