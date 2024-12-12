//
//  ViewController.swift
//  WeatherApp
//
//  Created by Berry, Brett A. (Student) on 12/1/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //outlets
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    //variables
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager() //setup the locationManger delegate and get location
    }
    
    //functions
    func setupLocationManager() {
        locationManager.delegate = self
        
        // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            // Request permission if not already authorized
            locationManager.requestWhenInUseAuthorization()
        } else {
            print("Location services are not enabled.")
            // Fallback to a default location if services are not available
            fetchWeather(for: CLLocation(latitude: 37.3229978, longitude: -122.0321823)) //apple hq
        }
    }

    
    //CLLocation Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted
            locationManager.requestLocation()
            
        case .denied, .restricted:
            // Permission denied
            print("Location access denied.")
            fetchWeather(for: CLLocation(latitude: 37.3229978, longitude: -122.0321823)) // Apple headqurters again
        
        case .notDetermined:
            // The user hasn't made a choice yet, request authorization
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            // Handle unknown cases
            print("Unknown location authorization status")
        }
    }

    
    //whenever the locations got updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchWeather(for: location)
        }
    }
    
    //default back to Cupertino
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
        currentLocationLabel.text = "Cupertino"
        fetchWeather(for: CLLocation(latitude: 37.3229978, longitude: -122.0321823)) //default to apple headquarters
    }
    
    //fetching weather data
    func fetchWeather(for location: CLLocation) {
        WeatherService.shared.fetchWeather(for: location, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.updateUI(with: weather)
                    self.getCityName(from: location)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        })
    }

    func getCityName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        
        // Perform reverse geocoding to get the address from the location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error getting city name: \(error.localizedDescription)")
                return
            }
            
            // Getting the city from the lat and long
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.currentLocationLabel.text = "\(city)"

                } else {
                    print("City name not available")
                }
            } else {
                print("No placemarks found")
            }
        }
    }

    //updating all the labels and image
    func updateUI(with weather: WeatherData){
        currentTempLabel.text = "\(weather.temperature)"
        currentTempLabel.textColor = weather.isDay ? UIColor.black : UIColor.white
        highTempLabel.text = "\(weather.maxTemperature)"
        highTempLabel.textColor = weather.isDay ? UIColor.black : UIColor.white
        lowTempLabel.text = "\(weather.minTemperature)"
        lowTempLabel.textColor = weather.isDay ? UIColor.black : UIColor.white
        self.view.backgroundColor = weather.isDay ? UIColor.systemTeal : UIColor.systemGray
        updateImage(with: weather)
        
        
    }
    
    //updating image based off a few cases
    func updateImage(with weather: WeatherData){
        if(weather.isDay){
            
            if(weather.condition.contains("Sunny")){
                conditionImage.image = UIImage(named: "Sunny_Image_Daytime")
            }
            else if(weather.condition.contains("Cloudy")){
                if(weather.condition.contains("Partly Cloudy")){
                    conditionImage.image = UIImage(named: "PartlyCloudy_Image_Daytime")
                }
                else{
                    conditionImage.image = UIImage(named: "Cloudy_Image_Daytime")
                }
            }
            else if(weather.condition.contains("Rainy") || weather.condition.contains("Showers")){
                conditionImage.image = UIImage(named: "Rainy_Image_Daytime")
            }
            else{
                conditionImage.image = UIImage(named: "Cloudy_Image_Daytime")
            }
        }
        else{
            if(weather.condition.contains("Sunny")){
                conditionImage.image = UIImage(named: "Sunny_Image_Nightime")
            }
            else if(weather.condition.contains("Cloudy")){
                if(weather.condition.contains("Partly Cloudy")){
                    conditionImage.image = UIImage(named: "PartlyCloudly_Image_Nightime")
                }
                else{
                    conditionImage.image = UIImage(named: "Cloudy_Image_Nightime")
                }
            }
            else if(weather.condition.contains("Rainy") || weather.condition.contains("Showers")){
                conditionImage.image = UIImage(named: "Rainy_Image_NIghtime")
            }
            else{
                conditionImage.image = UIImage(named: "Cloudy_Image_Nightime")
            }
        }
        

    }


}

