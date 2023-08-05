//
//  WeatherManager.swift
//  ForecastApp
//
//  Created by Hüdahan Altun 
//


import Foundation
import UIKit
import CoreLocation


struct WeatherManager{
    
    var weatherURL = Api.weatherURL //apı url

    func fetchWeatherConditionatCityName(cityName:String,completion:@escaping(WeatherModel?)->Void){
        
        let urlString = "\(weatherURL)&q=\(cityName)" //api adresini düzenliyoruz ve arayacağımız sehir adını giriyoruz.
        
        performRequest(urlString: urlString){
            
            weather in
            
             if let weather = weather {
                completion(weather)
             } else {
                 completion( nil)
             }
        }
    }

    func  fetchWeatherConditionatUserLocation(latitude:CLLocationDegrees,longitude:CLLocationDegrees,completion: @escaping (WeatherModel?)->Void){//kullanıcının konumuna göre bize o şehrin o günkü hava durumu bilgisini veren fonksiyon
       
       let coordinates = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)" //api adresini düzenliyoruz ve corelocaiton'dan gelen koordinat veirleri ni url' şeklinde alıyoruz
       
        performRequest(urlString: coordinates) { weather in
           
            if let weather = weather {
               completion(weather)
            } else {
                completion( nil)
            }
        }
   }
    
    
    
    func performRequest(urlString: String, completion: @escaping (WeatherModel?) -> Void) {
        //apı ile
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("API isteği başarısız!")
                    completion(nil)
                } else if let safeData = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        completion(weather)
                    } else {
                        completion(nil)
                    }
                }
            }.resume()
        } else {
            completion(nil)
        }
    }
    

    private func parseJSON(weatherData:Data)->WeatherModel?{ //parse başarılı olur veya olmaz diye return'lü fonk tanımladık aşağıdaki bloklardan birinde hata gelirse direkt catch çalışacak ve nil return edilecek
        
        do{

            // json verilerini parse edip WeatherData sınıfına göre uyarladık
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            
            // ihtiyacımız olan verileri buradan aldık
            let name  = decodedData.name
            let temperature = decodedData.main.temp
            let conditionID = decodedData.weather[0].id
            let lat = decodedData.coord.lat
            let long = decodedData.coord.lon
            // verilerle yeni bir nesne oluşturduk.bu nesne ile arayüzümüzü şekillendireceğiz
            let weatherModel = WeatherModel(coditionID: conditionID, cityname: name, temperature: temperature,latitude: lat,longitude: long)
            
            print("şehir:\(weatherModel.cityname)")
            print("şehir lat:\(weatherModel.latitude)")
            print("şehir long:\(weatherModel.longitude)")
            print("hava şuan:\(weatherModel.conditionName)")
            print("hava sıcaklık:\(weatherModel.temperature)")
            print("json parse basarılı")
            
            return weatherModel
         
        }catch{

            print("json parse başarısız!")

            return nil // hata durumunda nil döndür
        }
    }
    
    
}


  
