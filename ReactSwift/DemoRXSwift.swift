//
//  DemoRXSwift.swift
//  ReactSwift
//
//  Created by Raju on 03/07/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DemoRx: UIViewController {
    
    var name = PublishSubject<String>();
    let bag  = DisposeBag();
    
    override func viewDidLoad() {
        
        method1();
        
        name.asObservable().subscribe(onNext:{
            print("Value of name is");
            print($0);
        }).disposed(by: bag);
        
        method1();
    }
    
    func method1() {
        name.onNext("New Name");
    }
    
}

