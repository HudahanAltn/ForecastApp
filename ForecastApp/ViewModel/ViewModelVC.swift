//
//  ViewModelVC.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//


import Foundation
import CoreLocation

class ViewModelVC{

    var receivedWeather:Observable<WeatherModel> = Observable() // 7- bu aslında bir nevi veritabanından gelen yanıtı temsil eden yapıdır."merhaba" bunun içine yerleştirilir.Artık veritabnaından ne tür tipli veri geliyorsa içeriğini ona göre belirleriz.String gelsin diyelim.Bunu optional yapamayız çünkü buna abone olacak her zaman böyle bir nesne olmalıdır.
    
    var receivedSevenDaysWeather:Observable<WeatherDataSeven> = Observable()
    
    
    func loadDataWithLocation(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
       
        WeatherManager().fetchWeatherConditionatUserLocation(latitude: latitude, longitude: longitude){
            
            weather in
            
            self.receivedWeather.value = weather
        }
    }
    
    
    func loadSevenDaysWeatherDataWithLocaiton(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        
        WeatherManagerSeven().fetchSevenDaysWeatherConditionatUserLocation(latitude: latitude, longitude: longitude){
            
            weather in
            
            self.receivedSevenDaysWeather.value = weather
        }
        
    }
    
    func loadDataWithCityName(cityName:String){
       
        WeatherManager().fetchWeatherConditionatCityName(cityName: cityName){
            
            weather in
            
            self.receivedWeather.value = weather
        }
    }
    
    

}
