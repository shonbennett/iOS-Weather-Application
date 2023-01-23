//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Shon Bennett on 5/26/22.
//

import Foundation

//VIEW MODEL
//ObservableObject protoco allows instances of WeatherViewModel class to be used inside views. Wghen changes happen, the view's display will update

final class WeatherViewModel: ObservableObject {
    
    //create a weather object
    @Published var weather: TodayData?
    @Published var main:String? //var we will use to control background color of app
    
    //initializes our Published weather object
    init() {
        //set up the url session
        let session = URLSession.shared
        let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=37.5407&lon=-77.4360&exclude=minutely&appid=15d1f5a3c15a1a2a9f1c9406b9095042")
        
        //create a dataTask from our session
       let dataTask = session.dataTask(with: apiURL!) { data, response, error in
           
           //check if no errors and if we have actual data
           if error == nil && data != nil {
               
               //create a decoder and use it to create a Weather instance from data garthered from api
               let decoder = JSONDecoder();
               
               do { //place the decoder.decode in do catch bc the decode method could throw an error, which would require error handling
                   //create a TodayData object from the data we collected
                   let weatherData = try decoder.decode(TodayData.self, from: data!)
                   //set the main Publishd var to this (mainInfo contains the main weather)
                   let mainInfo = weatherData.current.weather[0].main
                   
                   //DispatchQueue makes the main thread update the UI (has to be done this way or Xcode yells about "background threads")
                   DispatchQueue.main.async {
                       //set our @Property weather var to the weatherData instance we created
                       self.weather = weatherData
                       self.main = mainInfo
                   }
                   
               } catch let error {
                   print("There was an error that occurred during the decode method's execution ")
                   print("Error: \(error.localizedDescription)")
               }
               
           }
           
        }//end of dataTask creation
        dataTask.resume(); //use resume method on dataTask to actually send off our request to the weather api
    } ///end of init
    
}

