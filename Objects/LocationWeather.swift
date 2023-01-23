//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by Shon Bennett on 5/25/22.
//

import Foundation


//MODEL VIEW
//ObservableObject protoco allows instances of LocationWeather class to be used inside views. Wghen changes happen, the view's display will update
class LocationWeather : ObservableObject {
    //create a weather object
    @Published var weather: Weather?
    
    //initializes our object
    init() {
        //CALL the api
        let session = URLSession.shared
        
        let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=37.5407&lon=-77.4360&exclude=minutely,alerts,daily&appid=49301abe2e8639d74da5e9c43825fd6f")
        
        //create a dataTask from our session
       let dataTask = session.dataTask(with: apiURL!) { data, response, error in
           
           //check if forr errors and if we have atual data
           if error == nil && data != nil {
               
               //PARSE the data from the api
               //create a decoder and use it to create a Weather instance from data garthered from api
               let decoder = JSONDecoder();
               
               do { //place the decoder.decode in do catch bc the decode method could throw an error, which would require error handling 
                   
                   let weatherData = try decoder.decode(Weather.self, from: data!)
                   
                   //DispatchQueue makes the main view update itself 
                   DispatchQueue.main.async {
                       //set our @Property weather var to the weatherData instance we created
                       self.weather = weatherData
                   }
               } catch {
                   print("There was an error that occurred during the decode method's execution ")
               }
               
           }
           
        }//end of dataTask creation
        dataTask.resume(); //use resume method on dataTask to actually send off our request to the weather api
    } ///end of init
    
    
}
