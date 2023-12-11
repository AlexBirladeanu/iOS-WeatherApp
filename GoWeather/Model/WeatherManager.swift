//
//  WeatherManager.swift
//  GoWeather
//
//  Created by Alex Bîrlădeanu on 11.12.2023.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherModel: WeatherModel)
    func didFailUpdate(_ error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName city: String) {
        let urlString = getUrl() + "&q=" + city
        performRequest(withUrl: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = getUrl() + "&lat=\(latitude)" + "&lon=\(longitude)"
        performRequest(withUrl: urlString)
    }
    
    private func performRequest(withUrl urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    return
                }
                if let safeData = data {
                    if let weatherData = parseJson(safeData) {
                        let model = WeatherModel(cityName: weatherData.name, temperature: String(format: "%.1f", weatherData.main.temp), conditionId: weatherData.weather[0].id)
                        delegate?.didUpdateWeather(model)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJson(_ data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(WeatherData.self, from: data)
        } catch {
            delegate?.didFailUpdate(error)
        }
        return nil
    }
        
    private func getUrl() -> String {
        let key = KeyChainService.shared.loadApiKeyFromKeychain()
        return "https://api.openweathermap.org/data/2.5/weather?appid=\(key)&units=metric"
    }
}
