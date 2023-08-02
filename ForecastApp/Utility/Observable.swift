//
//  Observable.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//



class Observable<T>{// bu class generic class olarak isimlendirilir ve içine herhangibir veir alabilir.
    
    
    var value:T?{//2- T tipinde bir value tanımlıyoruz
        
        didSet{//6-value her değiştiğinde bind metodunu çağırmamız lazım
            
            _callback?(value)// 7-çağrılma
        }
    }
    
    
    private var _callback:((T?)->Void)? // 4- şimdi closure'ı elimizde tutmak lazım çünkü hemen çağrılmıcak value değiştiği zaman çağrılacak.
    func bind(callback:@escaping (T?)->Void){//3-bind fonskiyonu uı elemanları üzerinde ile viewModelden gelen verileri göstermek için bağlama yapacak.bu fonksiyonda parametre olarak bir closure alır.Viewmodel'den ne tür tipte(string,int,class...) veriler geleceğini bilmediğimiz için closure T tipli olarak tanımlanır.T yi dışarıya yani uı'a vereceğimiz bind fonksiyonudur.closure hemen çağrılmayacağı için "@escaping" ile yazılmalıdı.
        
        _callback = callback //5- bind gövdesinde closure'ı tutuyoruz.
    }
    
    
}

