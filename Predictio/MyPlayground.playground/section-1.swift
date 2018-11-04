// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let apiKey = "da703e80f1937b3164584bdfb24b6030"

let baseUrl = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/")

let forecastUrl = NSURL(string: "37.8267,-122.423", relativeToURL:baseUrl)

let weatherData = NSData(contentsOfURL: forecastUrl!, options: nil, error:nil)
