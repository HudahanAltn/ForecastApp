//
//  WeatherManagerTests.swift
//  ForecastAppTests
//
//  Created by Hüdahan Altun on 6.08.2023.
//


//class viewcontroller:viewmodel{
//
//}

import XCTest
@testable import ForecastApp

import XCTest

class WeatherManagerTests: XCTestCase {
    
    var WeatherManagerUnderTest: WeatherManager?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        WeatherManagerUnderTest = WeatherManager()
    }

    override func tearDownWithError() throws {
//         Put teardown code here. This method is called after the invocation of each test method in the class.
        WeatherManagerUnderTest = nil
    }
    
    func testParsingValidJSON() {
        // Given MOCK
     
       
        
        let jsonData = Mock().currentWeatherJSON.data(using: .utf8)!
        
        // When
        let weatherModel = WeatherManagerUnderTest!.parseJSON(weatherData: jsonData)
        
        // Then
        XCTAssertNotNil(weatherModel, "Weather model should not be nil")
        XCTAssertEqual(weatherModel?.cityname, "Trabzon Province")
        XCTAssertEqual(weatherModel?.temperature, 25.05)
        XCTAssertEqual(weatherModel?.conditionID, 803)
        XCTAssertEqual(weatherModel?.latitude, 40.9167)
        XCTAssertEqual(weatherModel?.longitude, 39.8333)
    }
    
    func testParsingInvalidJSON() {
        // Given
        let invalidJSON = """
        {
            "invalid_key": "invalid_value"
        }
        """
        let jsonData = invalidJSON.data(using: .utf8)!
        
        // When
        let weatherModel = WeatherManagerUnderTest!.parseJSON(weatherData: jsonData)
        
        // Then
        XCTAssertNil(weatherModel, "Weather model should be nil")
    }
    
    func testPerformRequestWithValidURL() {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=8ddadecc7ae4f56fee73b2b405a63659&units=metric&q=Trabzon"
        
        let expectation = XCTestExpectation(description: "api çağrısı")
        
        WeatherManagerUnderTest?.performRequest(urlString: urlString) { weather in
            XCTAssertNotNil(weather, "Weather should not be nil")
            expectation.fulfill()
        }
      
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPerformRequestWithInvalidURL() {
        let urlString = "geçersizmkfşklglak"
        
        let expectation = XCTestExpectation(description: "api çağrısı")
        
        WeatherManagerUnderTest?.performRequest(urlString: urlString) { weather in
            XCTAssertNil(weather, "Weather should be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testfetchWeatherConditionatUserLocationValidModel(){
        
 
        let expectation = XCTestExpectation(description: "weathermodellocation çağrısı")
        
        let lat = 40.99 , lon = 39.66
        
        let TrabzonModel = WeatherModel(coditionID: 803, cityname: "Trabzon", temperature: 27.61, latitude: 40.99, longitude: 39.66)
        
        WeatherManagerUnderTest?.fetchWeatherConditionatUserLocation(latitude: lat, longitude: lon){
            weathermodel in
            
           XCTAssertEqual(weathermodel, TrabzonModel)
            
            expectation.fulfill()
        }
       
        wait(for: [expectation],timeout: 1.0)
    }
    
    func testFetchWeatherConditionatCityName(){
        
        let expectation = XCTestExpectation(description: "weathermodelname çağrısı")
    
        let TrabzonModel = WeatherModel(coditionID: 803, cityname: "Trabzon", temperature: 27.61, latitude: 40.99, longitude: 39.66)
        
        WeatherManagerUnderTest?.fetchWeatherConditionatCityName(cityName:"Trabzon"){
            weathermodel in
            
           XCTAssertEqual(weathermodel, TrabzonModel)
            
            expectation.fulfill()
        }
        wait(for: [expectation],timeout: 1.0)
    }

  
}
