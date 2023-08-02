//
//  WeatherDataSeven.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//

import Foundation


struct WeatherDataSeven:Codable{
    
    var daily:[Daily]
    
    
}

struct Daily:Codable{
    
    var dt:Int32
    var temp:Temp
    var weather:[WeatherSeven]
    
    
}

struct Temp:Codable{
    
    var min:Double
    var max:Double
}

struct WeatherSeven:Codable{
    
    var icon:String
    
    func getIcon(iconCode:String,completion:@escaping(Data?)->Void){// openweather icon çekmek için oluşturulan fonksiyon.iconise "iconCode" değerleri ile çekilecek.
        
        if let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png"){
            
            URLSession.shared.dataTask(with: url){
                data,response,error in
                
                if error != nil {
                    print("API icon isteği başarısız!")
                  
                    completion(nil)
                } else if let safeData = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    completion(safeData)
                }else{
                    completion(nil)
                }
            }.resume()
        }
    }
}
