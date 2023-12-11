//
//  WeatherModel.swift
//  GoWeather
//
//  Created by Alex Bîrlădeanu on 11.12.2023.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: String
    let conditionId: Int
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
