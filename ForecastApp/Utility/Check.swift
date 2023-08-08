//
//  Check.swift
//  ForecastApp
//
//  Created by Hüdahan Altun
//

import Foundation

struct Check{
    
    static func convertToNonTurkishCharacters(_ text: String) -> String? {//turkce karakter kontorlü yapan ve karakter girilmişse filtreleyip değiştiren fonksiyon
        
        let nonTurkishCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+{}[]|\"<>,.?/~`'-=\\ ")
        
        let filteredText = text.components(separatedBy: nonTurkishCharacterSet.inverted).joined()
        
        return filteredText.isEmpty ? nil : filteredText
}

}
