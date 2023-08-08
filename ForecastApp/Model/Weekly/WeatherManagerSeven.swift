//
//  WeatherManagerSeven.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//


import Foundation
import UIKit
import CoreLocation


struct WeatherManagerSeven{
    
    var weatherURL = Api.sevenDaysWeatherURL //apı url


    func fetchSevenDaysWeatherConditionatUserLocation(latitude:CLLocationDegrees,longitude:CLLocationDegrees,completion: @escaping (WeatherDataSeven?)->Void){//kullanıcının konumuna göre bize o şehrin o günkü hava durumu bilgisini veren fonksiyon
       
       let coordinates = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)" //api adresini düzenliyoruz ve corelocaiton'dan gelen koordinat veirleri ni url' şeklinde alıyoruz
       
        performRequest(urlString: coordinates) { weather in
           
            if let weather = weather {
               completion(weather)
            } else {
                completion( nil)
            }
        }
   }
    
    func performRequest(urlString: String, completion: @escaping (WeatherDataSeven?) -> Void) {
        //apı ile
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("API isteği başarısız!")
                    completion(nil)
                } else if let safeData = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let weather = self.parseJSONSevenDays(weatherData: safeData) {
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
    

     func parseJSONSevenDays(weatherData:Data)->WeatherDataSeven?{ //parse başarılı olur veya olmaz diye return'lü fonk tanımladık aşağıdaki bloklardan birinde hata gelirse direkt catch çalışacak ve nil return edilecek
        
        do{

            // json verilerini parse edip WeatherData sınıfına göre uyarladık
            let decodedData = try JSONDecoder().decode(WeatherDataSeven.self, from: weatherData)

            return decodedData
         
        }catch{

            print("json parse başarısız!")

            return nil // hata durumunda nil döndür
        }
    }
    
    
}


  

