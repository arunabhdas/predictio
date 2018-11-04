//
//  Current.swift
//  SmartApp
//
//  Created by coder on 12/31/14.
//  Copyright (c) 2014 appliaison. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    
    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as! NSDictionary
        
        
        temperature = currentWeather["apparentTemperature"] as! Int
        humidity = currentWeather["humidity"] as! Double
        precipProbability = currentWeather["precipProbability"] as! Double
        summary = currentWeather["summary"] as! String
        
        
        let currentTimeIntValue = currentWeather["time"] as! Int
		currentTime = dateStringFromUnixTime(unixTime: currentTimeIntValue)
        
        
        let iconString = currentWeather["icon"] as! String
		icon = weatherIconFromString(stringIcon: iconString)
        
        // println(currentTime)
        
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
		let timeInSeconds = TimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
		return dateFormatter.string(from: weatherDate as Date)
        
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        switch(stringIcon) {
            case "clear-day":
                imageName = "clear-day"
            case "clear-night":
                imageName = "clear-night"
            case "rain":
                imageName = "rain"
            case "snow":
                imageName = "snow"
            case "sleet":
                imageName = "sleet"
            case "wind":
                imageName = "wind"
            case "fog":
                imageName = "fog"
            case "cloudy":
                imageName = "cloudy"
            case "party-cloudy-day":
                imageName = "partly-cloudy"
            case "partly-cloudy-night":
                imageName = "cloudy-night"
            default:
                imageName = "default"
        }
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    
    
    
    
    
}
