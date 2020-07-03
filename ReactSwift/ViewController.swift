//
//  ViewController.swift
//  ReactSwift
//
//  Created by Raju on 24/05/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import UIKit
import RxSwift


class ViewController: UIViewController,PhotosDelegate {
    
    
    func photosClearButtonClicked() {
        print("Method executed in Main controller");
    }
    var value = 10;
    let disposeBag = DisposeBag();
    
    override func loadView() {
        super.loadView();
        self.view.backgroundColor = .white;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 30));
        button.setTitle("Click Me", for: .normal);
        button.setTitleColor(.black, for: .normal);
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside);
        self.view.addSubview(button);
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonClicked() {
        
        let photos = PhotosTableView();
        
        photos.namesObservable.subscribe(onNext: { (names) in
            print(names);
            print("From View Controller");
        }, onDisposed: {
            print("subScriber disposed")
        }).disposed(by: disposeBag);
        
        photos.photoDelegate = self;
        photos.modalPresentationStyle = .fullScreen;
        
        self.navigationController?.pushViewController(photos, animated: true);

        //self.navigationController?.pushViewController(APIHandlingExample(), animated: true);
    }
    
    deinit {
        print("View controller de-initialised");
    }

}

class Second:UIViewController  {
    
}


class API {
    class func download(file:String) {
        //http://itunes.apple.com/lookup?id=434682528&country=NZ
        let request = URLRequest(url: URL(string: file)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })

        task.resume()
    }
}
