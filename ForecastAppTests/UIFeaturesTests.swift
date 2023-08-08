//
//  UIFeaturesTests.swift
//  ForecastAppTests
//
//  Created by Hüdahan Altun on 6.08.2023.
//

import XCTest
@testable import ForecastApp

final class UIFeaturesTests: XCTestCase {

    var FeaturesUnderTesting:UIFeatures!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        FeaturesUnderTesting = UIFeatures()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        FeaturesUnderTesting = nil
    }

   

    func test_showTodayNameFromUnixDate(){
        let weather1:WeatherSeven = WeatherSeven(icon: "04d")
        let weather2:WeatherSeven = WeatherSeven(icon: "03d")
        var weatherArray = [WeatherSeven]()
        weatherArray.append(weather1)
        weatherArray.append(weather2)
        
        let weatherCond1:Daily = Daily(dt: 1000000, temp: Temp(min: 20, max: 25), weather: weatherArray)//pazartesi günü
        let weatherCond2:Daily = Daily(dt: 3000000, temp: Temp(min: 24, max: 30), weather: weatherArray)//çarşamba günü
        
        var weatherConditions = [Daily]()
        weatherConditions.append(weatherCond1)
        weatherConditions.append(weatherCond2)
        
//        var indexPath = IndexPath(row: 0, section: 1)//pazartesi indexlenir
        let indexPath = IndexPath(row: 1, section: 1)//çarşamba indexlenir
       
        let result = FeaturesUnderTesting.showTodayNameFromUnixDate(weatherConditions: weatherConditions, indexPath: indexPath)
        
        XCTAssertEqual(result, "Çarşamba")
    }
    
   
}
