//
//  SevenDayWeatherConditionViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 3.08.2023.
//

import UIKit

class SevenDayWeatherConditionViewController: UIViewController {

    
    var searchedWeather:WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let weather = searchedWeather{
            
            print("nesne geldi!!! :\(weather.cityname)")
            
        }

    }
    

  

}
