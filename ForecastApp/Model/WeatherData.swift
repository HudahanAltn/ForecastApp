//
//  WeatherData.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//


import Foundation

//Json parse için sınıf oluşturuyoruz çünkü json verileride nesne tabanlıdır. bu nesnelerin swift class'ını oluşturursak parse etmesi daha  kolaylaşır

struct WeatherData:Codable{ // ANA SINIF
    
    var name:String
    var main:Main
    var weather:[Weather]
}


struct Main:Codable{
    
    var temp:Double
}


struct Weather:Codable{
    
    var description:String
    var id:Int
}


//
//{
//   "coord":{
//      "lon":28.9833,
//      "lat":41.0351
//   },
//   "weather":[ //Weather Class
//      {
//         "id":800,
//         "main":"Clear",
//         "description":"clear sky",
//         "icon":"01n"
//      }
//   ],
//   "base":"stations",
//   "main":{            //Main Class
//      "temp":23.45,
//      "feels_like":23.65,
//      "temp_min":22.09,
//      "temp_max":23.92,
//      "pressure":1010,
//      "humidity":69
//   },
//   "visibility":10000,
//   "wind":{
//      "speed":4.12,
//      "deg":30
//   },
//   "clouds":{
//      "all":0
//   },
//   "dt":1690840560,
//   "sys":{
//      "type":1,
//      "id":6970,
//      "country":"TR",
//      "sunrise":1690858760,
//      "sunset":1690910482
//   },
//   "timezone":10800,
//   "id":745042,
//   "name":"Istanbul",
//   "cod":200
//}

