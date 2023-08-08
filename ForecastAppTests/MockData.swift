//
//  MockData.swift
//  ForecastAppTests
//
//  Created by Hüdahan Altun on 8.08.2023.
//

import Foundation

struct Mock{
    
    let  currentWeatherJSON = """
        {
           "coord":{
              "lon":39.8333,
              "lat":40.9167
           },
           "weather":[
              {
                 "id":803,
                 "main":"Clouds",
                 "description":"broken clouds",
                 "icon":"04d"
              }
           ],
           "base":"stations",
           "main":{
              "temp":25.05,
              "feels_like":25.65,
              "temp_min":25.05,
              "temp_max":25.05,
              "pressure":1008,
              "humidity":78
           },
           "visibility":10000,
           "wind":{
              "speed":2.57,
              "deg":350
           },
           "clouds":{
              "all":75
           },
           "dt":1691493808,
           "sys":{
              "type":1,
              "id":6995,
              "country":"TR",
              "sunrise":1691461386,
              "sunset":1691512183
           },
           "timezone":10800,
           "id":738647,
           "name":"Trabzon Province",
           "cod":200
        }
        """
}
