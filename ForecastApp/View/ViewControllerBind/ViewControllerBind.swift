//
//  ViewControllerBind.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 5.08.2023.
//

import UIKit

class ViewControllerBind: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if Connection.isInternetAvailable(){
            
            performSegue(withIdentifier: "toMainVC", sender: nil)
            
        }else{
            
            let alertController = UIAlertController(title: "Hata", message: "Lütfen internet bağlantınızı kontrol ediniz!", preferredStyle: .alert)
            present(alertController, animated: true)
        }
    }
    

    
    
}
