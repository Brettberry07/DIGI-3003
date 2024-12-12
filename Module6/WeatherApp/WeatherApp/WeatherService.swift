//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Berry, Brett A. (Student) on 12/1/24.
//

import Foundation
import CoreLocation

/*
 struct WeatherData {
     var temperature: Int
     var maxTemperature: Int
     var minTemperature: Int
     var condition: String
     var isDay: Bool
 }
 
 try fetch current_location else {
 default to apple headquarters
 }
 
 set query to fetch all data in struct
 try fetch weather_data_from_location else {
 throw error
 }
 
check for httpResponse of 200 (OK)

Finally parse json data into struct
return struct
 */

class WeatherService {
    static let shared = WeatherService()
    
    /*  API requries a grid based data endpoint so that's what this function does,
        we get the lat and long from the view controller then convert this into the
        proper grid data required by the API. Along this way we take into account
        various errors and handle them accoridingly.
     
        This gives us the forecast URL we need in order to get the proper data
        from the place we are requesting.
     */
    func fetchWeather(for location: CLLocation, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        print("called fetchWeather")
        
        //api takes lat and long for location
        let pointsURL = "https://api.weather.gov/points/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        //Make sure it is a valid url
        guard let validPointsURL = URL(string: pointsURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
            return
        }
        
        //get the data from the url
        URLSession.shared.dataTask(with: validPointsURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            //make sure we recived the OK response
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Failed to fetch grid data", code: 2, userInfo: nil)))
                return
            }
            
            //parse into usable grid data
            do {
                let gridData = try JSONDecoder().decode(GridData.self, from: data)
                let forecastURL = gridData.forecastURL
                
                //get the forecast data that we need
                self.fetchForecast(from: forecastURL, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /*
        This takes in the forecast url we got from the last function
        This is how we get the actual weather data we want, like the temp and other things
        We do this by requesting the data from the url, which then returns the forexast for periods.
        These periods can last a bit so it's not hourly, more like a general of what it is at the time.
        So the weather app gives a min and max value fo the data from today to roughly 2-3 days from now.
     
        Once we get this json data and understand what it is representing, we can map this to the
        WeatherData struct. This struct allows us an easy way to access the data that we need.
        We then use some simple anonymous functions to get exactly what we need: like min, max, etc.
     
        We then return the WeatherData struct
     */
    
    private func fetchForecast(from url: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        guard let validURL = URL(string: url) else {
            //checking valid url
            completion(.failure(NSError(domain: "Invalid Forecast URL", code: 3, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { data, response, error in
            if let error = error {
                //if we aren't able to access the api call
                completion(.failure(error))
                return
            }
            
            //check for the OK response
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Failed to fetch forecast data", code: 4, userInfo: nil)))
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                
                // Extract the current period
                guard let currentPeriod = forecastResponse.properties.periods.first else {
                    completion(.failure(NSError(domain: "No forecast data available", code: 5, userInfo: nil)))
                    return
                }
                
                // Calculate max and min temperatures for the forecast period
                
                let forecastPeriod = forecastResponse.properties.periods
                let maxTemperature = forecastPeriod.map { $0.temperature }.max() ?? currentPeriod.temperature
                let minTemperature = forecastPeriod.map { $0.temperature }.min() ?? currentPeriod.temperature
                
                // Create WeatherData object
                let weatherData = WeatherData(
                    temperature: currentPeriod.temperature,
                    maxTemperature: maxTemperature,
                    minTemperature: minTemperature,
                    condition: currentPeriod.shortForecast,
                    isDay: currentPeriod.isDaytime
                )
                
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
