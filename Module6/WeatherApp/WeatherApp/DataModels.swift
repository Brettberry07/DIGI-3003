//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Berry, Brett A. (Student) on 12/1/24.
//

import Foundation

/*
 This file repsents all the data structures needed for the api calls
 We start by decoding everything inot the WeatherData struct
 For that we need the GridData, this is what represents our location data, forecast data, and init for the fetch wetaher func
 We then need the ForecastPeriod, reponse, and properties to properly search trhough the api.
 */


struct WeatherData {
    var temperature: Int
    var maxTemperature: Int
    var minTemperature: Int
    var condition: String
    var isDay: Bool
}

struct GridData: Decodable {
    let forecastURL: String
    
    enum CodingKeys: String, CodingKey {
        case properties
    }
    
    enum PropertiesKeys: String, CodingKey {
        case forecast = "forecast"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)
        forecastURL = try properties.decode(String.self, forKey: .forecast)
    }
}

struct ForecastPeriod: Decodable {
    let temperature: Int
    let isDaytime: Bool
    let shortForecast: String
}

struct ForecastResponse: Decodable {
    let properties: ForecastProperties
}

struct ForecastProperties: Decodable {
    let periods: [ForecastPeriod]
}

