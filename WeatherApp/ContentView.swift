//
//  ContentView.swift
//  WeatherApp
//
//  Created by Shon Bennett on 5/25/22.
//

import SwiftUI

//VIEW 
struct ContentView: View {
    
    //created an ObservedObject of the WeatherViewModel class
    @ObservedObject var location = WeatherViewModel();
    
    var body: some View {
        
        if let weather = location.weather {
            ZStack {
                //assigns backgrond color
                LinearGradient(gradient: Gradient(colors: weather.current.getBackgroundColor(main: location.main ?? "Clear", current: weather.current)),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing:5) {
                    Text("Richmond, VA")
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.white).padding()
                        
                    
                    VStack {
                        //insert the condition picture right here
                        Image(systemName: getIcon(description: weather.current.weather[0].description!, main: weather.current.weather[0].main!, current: weather.current)).renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height:180)
                        //the .description turns Double into a String
                        Text("\(weather.current.convertToFarenheit(temperature: weather.current.temp))°").font(.system(size: 50, weight: .medium, design: .default)).foregroundColor(.white)
                        Text("\(weather.current.weather[0].main!)").font(.system(size: 22, weight: .medium, design: .default)).foregroundColor(.white)
                        Text("\(weather.current.weather[0].description!)").font(.system(size: 22, weight: .medium, design: .default)).foregroundColor(.white)
                    }.padding(.bottom, 50)
                    
                    //showIndicators determines whether we have a slide bar or not
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 20) {
                            //displays the next 20 hours worth of weather
                            HourlyScrollView(index: 1, location: location)
                            HourlyScrollView(index: 2, location: location)
                            HourlyScrollView(index: 3, location: location)
                            HourlyScrollView(index: 4, location: location)
                            HourlyScrollView(index: 5, location: location)
                            HourlyScrollView(index: 6, location: location)
                            HourlyScrollView(index: 7, location: location)
                            HourlyScrollView(index: 8, location: location)
                            HourlyScrollView(index: 9, location: location)
                            HourlyScrollView(index: 10, location: location)
                        }
                        
                    }.padding(.horizontal, 30).padding(.vertical, 30)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        DailyScrollView(index: 1, location: location)
                        DailyScrollView(index: 2, location: location)
                        DailyScrollView(index: 3, location: location)
                        DailyScrollView(index: 4, location: location)
                        DailyScrollView(index: 5, location: location)
                        DailyScrollView(index: 6, location: location)
                        DailyScrollView(index: 7, location: location)
                    }
                    
                    Spacer()
                    
                
                }
                
            } //end Zstack
            
        } else {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.blue, Color("lightBlue")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                
                Text("Gathering Information").font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.white).padding()
            }
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HourlyScrollView: View {
    
    //pass in an index var and the ObservableObject we will use in ContentView
    var index:Int //leaving this var un-iniatialized makes it a parameter (see in content view)
    var location:WeatherViewModel
    
    var body: some View {
        let weather = location.weather
        //gets the icon to describe the current weather
        let symbol = getIcon(description: weather?.hourly[index].weather[0].description ?? "", main: weather?.hourly[0].weather[0].main ?? "", current: weather!.current)
        //gets the temperature in Fahrenheit
        let temperature = convertToFahrenheit(temperature: weather?.hourly[index].temp ?? 0.0)
        //gets the hourly time
        let hourlyTime = UNIXtoHour(unixTime :Double(weather?.hourly[index].dt ?? 0) )
        
        VStack {
            //?? allows us to provide a default value in case an arguement is nil
            Text("\(hourlyTime)")
                .foregroundColor(.white)
            //Icon Here
            Image(systemName: symbol)
                .renderingMode(.original)
            
            Text("\(temperature)°")
                .foregroundColor(.white)
        }
    }
}

struct DailyScrollView: View {
    
    //pass in an index var and the ObservableObject we will use in ContentView
    var index:Int //will have to initialize the view with an index value
    var location:WeatherViewModel
    
    var body: some View {
        let weather = location.weather
        //gets the icon to describe the current weather
        let symbol = getDailyIcon(description: weather?.daily[index].weather[0].description ?? "", main: weather?.daily[index].weather[0].main ?? "", current: weather!.current)
        //gets the hourly time
        let dayOfWeek = UNIXtoDay(unixTime :Double(weather?.daily[index].dt ?? 0) )
        //get the max and min temps for the day
        let maxTemp = convertToFahrenheit(temperature: weather?.daily[index].temp?.max ?? 0.0)
        let minTemp = convertToFahrenheit(temperature: weather?.daily[index].temp?.min ?? 0.0)
        
        HStack {
            //?? allows us to provide a default value in case an arguement is nil
            Text("\(dayOfWeek)")
                .foregroundColor(.white)
            //Icon Here
            Image(systemName: symbol)
                .renderingMode(.original)
            
            Text("\(maxTemp)°/\(minTemp)°")
                .foregroundColor(.white)
        }.padding(.bottom, 10)
    }
}

func UNIXtoHour(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h a"
    
    return dateFormatter.string(from: date)
}

func UNIXtoDay(unixTime: Double) -> String {
    let date = Date(timeIntervalSince1970: unixTime)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E MMM d"
    
    return dateFormatter.string(from: date)
}

func convertToFahrenheit(temperature: Double) -> Int {
    let farenTemp = 1.8*(temperature-273) + 32
    return Int(farenTemp)
}

//getIcon to be used in the hourly view
func getIcon(description: String, main: String, current:Current) -> String {
    if main == "Thunderstorm" {
        
        if description.range(of:"rain") != nil {
            return "cloud.bolt.rain.fill"
        } else {
            return "cloud.bolt.fill"
        }
    } else if main == "Drizzle"{
        return "cloud.drizzle.fill"
    } else if main == "Rain" {
        
        if description.range(of:"heavy") != nil || description.range(of:"extreme") != nil {
            return "cloud.heavyrain.fill"
        } else if description.range(of:"freezing") != nil {
            return "cloud.sleet.fill"
        }
        
        return "cloud.rain.fill"
            
    } else if main == "Snow" {
        
        if description.range(of:"sleet") != nil || description.range(of:"rain") != nil {
            return "cloud.sleet.fill"
        }
        
        return "cloud.snow.fill"
    } else if main == "Clear" {
        
        //if it is night time, we will use night icons for this weather
        if current.isNight(current: current) == true {
            return "moon.stars.fill"
        }
        
        return "sun.max.fill"
    } else if main == "Clouds" {
        
        if description.range(of:"scattered") != nil || description.range(of:"broken") != nil || description.range(of:"few") != nil{
            
            //if it is night time, we will use night icons for this weather
            if current.isNight(current: current) == true {
                return "cloud.moon.fill"
            }
            
            return "cloud.sun.fill"
        }
        
        return "cloud.fill"
    } else if main == "Smoke" {
        return "smoke.fill"
    } else if main == "Haze" {
        return "sun.haze.fill"
    } else if main == "Fog" {
        return "cloud.fog.fill"
    } else if main == "Tornado" {
        return "tornado"
    } else if main == "Squall" {
        return "wind"
    }
    
    //others: Mist, Dust, Sand, Ash
    //returns a question mark SF Image in case it fits none of them (may be extreme condition we did not account for) 
    return "exclamationmark.triangle.fill"
}

//to be used in daily view (so we do not use any night time symbols)
func getDailyIcon(description: String, main: String, current:Current) -> String {
    if main == "Thunderstorm" {
        
        if description.range(of:"rain") != nil {
            return "cloud.bolt.rain.fill"
        } else {
            return "cloud.bolt.fill"
        }
    } else if main == "Drizzle"{
        return "cloud.drizzle.fill"
    } else if main == "Rain" {
        
        if description.range(of:"heavy") != nil || description.range(of:"extreme") != nil {
            return "cloud.heavyrain.fill"
        } else if description.range(of:"freezing") != nil {
            return "cloud.sleet.fill"
        }
        
        return "cloud.rain.fill"
            
    } else if main == "Snow" {
        
        if description.range(of:"sleet") != nil || description.range(of:"rain") != nil {
            return "cloud.sleet.fill"
        }
        
        return "cloud.snow.fill"
    } else if main == "Clear" {
        
        return "sun.max.fill"
    } else if main == "Clouds" {
        
        if description.range(of:"scattered") != nil || description.range(of:"broken") != nil || description.range(of:"few") != nil{
            return "cloud.sun.fill"
        }
        return "cloud.fill"
    } else if main == "Smoke" {
        return "smoke.fill"
    } else if main == "Haze" {
        return "sun.haze.fill"
    } else if main == "Fog" {
        return "cloud.fog.fill"
    } else if main == "Tornado" {
        return "tornado"
    } else if main == "Squall" {
        return "wind"
    }
    
    //others: Mist, Dust, Sand, Ash
    //returns a question mark SF Image in case it fits none of them (may be extreme condition we did not account for)
    return "exclamationmark.triangle.fill"
}
