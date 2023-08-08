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

        if Connection.isInternetAvailable(){//internet var ise
            
            
            performSegue(withIdentifier: "toMainVC", sender: nil)// giriş sayfasına geç
            
        }else{// yoksa hata mesajı göster ve ekrenı kilitle
            
            let alertController = UIAlertController(title: "Hata", message: "Lütfen internet bağlantınızı kontrol ediniz!", preferredStyle: .alert)
            present(alertController, animated: true)
        }
    }

    
}
