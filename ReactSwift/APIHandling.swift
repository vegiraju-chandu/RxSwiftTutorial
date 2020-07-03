//
//  APIHandling.swift
//  ReactSwift
//
//  Created by Raju on 25/06/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class APIHandlingExample: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataTableView: UITableView!;
    var columns     = BehaviorRelay<[Columns]>(value: []);
    let disposeBag  = DisposeBag();
    var imagesDictionary = [String:UIImage?]();
    
    override func loadView() {
        super.loadView();
        self.view.backgroundColor = .white;
        dataTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height));
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.tableFooterView = UIView(frame: .zero);
        self.view.addSubview(dataTableView);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.addSubScribers();
        self.makeNetworkAPICall()
        /*self.makeAPICall()
            .asObservable()
            .subscribe(onNext: { newColumns in
                print("in subscriber method");
                DispatchQueue.main.async {[unowned self] in
                    self.columns.accept(newColumns);
                    self.dataTableView.reloadData();
                }
            })
            .disposed(by: disposeBag);*/
    }
    
    //MARK: UITableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.columns.value.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell");
        if ( cell == nil ) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        
        let column = self.columns.value[indexPath.row];
    
        if let imageURL = column.name {
            if imagesDictionary[imageURL] != nil {
                cell?.imageView?.image = imagesDictionary[imageURL]!;
            }else {
                self.downloadImageWithUrl(imageURL: imageURL, forCell: cell!);
            }
        }
        cell?.textLabel?.text = column.name ?? "";
        return cell!;
    }
    
    //MARK User Defined Methods
    
    func downloadImageWithUrl(imageURL: String, forCell:UITableViewCell ){
        
        DispatchQueue.global(qos: .utility).async {
            do {
                let imageData = try Data(contentsOf: URL(string: imageURL)!);
                let image = UIImage(data: imageData);
                self.imagesDictionary[imageURL] = image;
                forCell.imageView?.image = image;
            }catch {
                print("Image Downloaded Failed");
            }
        }
    }
    
    func makeAPICall () -> Observable<[Columns]> {
        
        let serverURL = "https://data.hawaii.gov/api/views/usep-nua7/rows.json?accessType=DOWNLOAD";
        
        let observable = Observable<[Columns]>.create { observer in
            
            Network.getApiCallWithRequestString(requestString: serverURL, completionBlock: { (response) in
                do {
                    let data = try JSONDecoder().decode(MainData.self, from: response)
                    if let columns = data.meta?.view?.columns {
                        observer.onNext(columns);
                    }
                }catch {
                    observer.onError(error);
                }
            }) { (error) in
                switch error {
                case .DATANOTFOUND: do {
                    print("Data not found");
                };
                case .UN_FORMATTEDURL: do {
                    print("Un formatter url");
                };
                case .NO_NOTWORK:
                    print("No notwork");
                }
            }
            return Disposables.create();
        }
        return observable;
    }
    
    func makeNetworkAPICall() {
        
        /*let serverURL = "https://data.hawaii.gov/api/views/usep-nua7/rows.json?accessType=DOWNLOAD";
        Network.getApiCallWithRequestString(requestString: serverURL, completionBlock: { (response) in
            do {
                let data = try JSONDecoder().decode(MainData.self, from: response)
                if let columns = data.meta?.view?.columns {
                    self.columns.accept(columns)
                }
            }catch {
                print("Found error in de-serialising");
            }
        }) { (error) in
            switch error {
                case .DATANOTFOUND: do {
                    print("Data not found");
                };
                case .UN_FORMATTEDURL: do {
                    print("Un formatter url");
                };
            }
        }*/
    }
    
    func addSubScribers() {
        
        self.columns
            .asObservable()
            .subscribe(onNext: { (newColumns) in
                DispatchQueue.main.async {
                    self.dataTableView.reloadData();
                }
            })
            .disposed(by: disposeBag);
    }
}
