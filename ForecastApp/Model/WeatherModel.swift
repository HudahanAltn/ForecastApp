//
//  WeatherModel.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//

import Foundation


class WeatherModel{
    
    var conditionID:Int // bu ID ye göre ekranda havadurumuna ait resim çıkacak
    var cityname:String// sehir ismi
    var temperature:Double //sıcaklık
    var latitude:Double
    var longitude:Double
    
    var temperatureString:String{//sıcaklıkğı stringe çevirdik
        
        return String(format:"%.1f", temperature)
    }
    
    var conditionName:String{//computed property ile ıd2ye göre resim çekmek için kullanacağız.
        
        switch conditionID{//buId ile ilgili resmin adını aldık
         
            //case ile aralık belirtioyurz.
        case 200...232:
            return "11d"
        
        case 300...321:
            return "9d"
            
        case 500...504:
            return "10d"
            
        case 520...531:
            return "09d"
           
        case 600...622:
            return "13d"
            
        case 700...781:
            return "50d"
            
        case 800:
            return "01d"
            
        case 801:
            return "02d"
            
        case 802:
            return "03d"
            
        case 803...804:
            return "04d"
    
        default:
            
            return "04d"
        }
        
    }
    
    init(coditionID:Int,cityname:String,temperature:Double,latitude:Double,longitude:Double){
        
        self.conditionID = coditionID
        self.cityname = cityname
        self.temperature = temperature
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(){
        
        self.conditionID = 0
        self.cityname = ""
        self.temperature = 0.0
        self.latitude = 0.0
        self.longitude = 0.0
    }
   
    func getIcon(iconCode:String,completion:@escaping(Data?)->Void){// openweather icon çekmek için oluşturulan fonksiyon.iconise "conditionName" değerleri ile çekilecek.
        
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
