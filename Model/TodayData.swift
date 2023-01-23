//
//  TodayData.swift
//  WeatherApp
//
//  Created by Shon Bennett on 5/28/22.
//

import Foundation
import SwiftUI

struct TodayData: Decodable {
    //instance variables
    var current:Current
    var hourly = [Hourly()]
    var daily = [Daily()]
    //var alerts = [Alerts()] //make alerts optional, because we will not have extreme weather alerts every day
    
}

struct Current: Decodable {
    //instance variables
    var dt:Int
    var temp:Double
    var feels_like:Double
    var weather = [Weather()];
    var sunrise:Int
    var sunset:Int
    
    //methods
    func convertToFarenheit(temperature: Double) -> Int {
        let farenTemp = 1.8*(temperature-273) + 32
        return Int(farenTemp)
    }
    
    //tests if it is night time (we passed sunrise and sunset)
    func isNight(current: Current) -> Bool {
        
        if current.dt > current.sunset && current.dt > current.sunrise {
            return true
        }
        return false
    }
    
    //use this method to get the main value, which will control the background color
    func getBackgroundColor(main:String, current: Current) -> [Color] {
        //declare var we will use for default case
        let blueSky:[Color] = [.blue, Color("lightBlue")]
        //test if it is night (we have passed sunrise and sunset)
        if isNight(current: current) == true {
            return [Color("lightBlack"), Color("purpleSky")]
        }
        //test for adverse weather 
        if main == "Thunderstorm" || main == "Tornado" || main == "Drizzle" ||
            main == "Mist" || main == "Dust" || main == "Sand" || main == "Ash" || main == "Smoke"
            || main == "Haze" || main == "Fog" || main == "Rain"{
            return [Color("lightBlack"), Color("gray")]
        } else if main == "Clouds" {
            //if it is partly cloudy, we still show blue sky
            if current.weather[0].description?.range(of:"scattered") != nil || current.weather[0].description?.range(of:"broken") != nil || current.weather[0].description?.range(of:"few") != nil{
                return blueSky
            } else { //if there are pure clouds in the sky, we show gray background 
                return [Color("lightBlack"), Color("gray")]
            }
        }
        
        return blueSky
    }
}

struct Weather: Decodable {
    //instance variables
    var id:Double?
    var main:String?
    var description:String?
}

struct Hourly:Decodable {
    var dt:Int?
    var temp:Double?
    var weather = [Weather()];
    
    func getDT() -> Int {
        if dt == nil {
            return 0
        }
        return self.dt!
    }
}

struct Daily:Decodable {
    var dt:Int?
    var temp: Temperature?
    var weather = [Weather()];
}

struct Temperature: Decodable {
    var min:Double
    var max:Double
    
}

struct Alerts:Decodable {
    var sender_name:String?
    var event:String?
    var start:Int?
    var end:Int?
    var description:String?
}
