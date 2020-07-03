//
//  PhotosTableView.swift
//  ReactSwift
//
//  Created by Raju on 17/06/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotosDelegate: class {
    func photosClearButtonClicked();
}

class PhotosTableView : UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    weak var photoDelegate:PhotosDelegate? = nil;
    var value = 1;
    let photosTable: UITableView = UITableView();
    let saveButton: UIButton     = UIButton();
    let clearButton: UIButton    = UIButton();
    
    private var names = BehaviorRelay<[String]>(value: []);
    
    private var name = PublishSubject<String>();
    
    private var disposeBag = DisposeBag();
    
    var namesObservable:Observable<[String]> {
        return names.asObservable();
    }
    
    var nameOb: Observable<String> {
        return name.asObservable();
    }
    
    
    
    override func loadView() {
        super.loadView();
        self.view.backgroundColor = .white;
        
        names.subscribe(onNext: { (names) in
            print(names);
            print("From View Controller");
        }, onDisposed: {
            print("subScriber disposed")
        }).disposed(by: disposeBag);
        
        /*Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {[unowned self](timer) in
            self.value += 1;
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        print("resources: \(RxSwift.Resources.total)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        name.onCompleted();
    }
    override func viewDidLoad() {
        
        super.viewDidLoad();
        photosTable.frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 200);
        photosTable.delegate = self;
        photosTable.dataSource = self;
        photosTable.tableFooterView = UIView(frame: .zero);
        
        saveButton.frame = CGRect(x: 0, y: photosTable.frame.maxY, width: 100, height: 50);
        saveButton.setTitle("Save", for: .normal);
        saveButton.setTitleColor(.black, for: .normal);
        saveButton.backgroundColor = .lightGray;
        saveButton.addTarget(self, action: #selector(self.saveButtonClicked), for: .touchUpInside);
        
        clearButton.frame = CGRect(x: self.view.bounds.size.width - 110, y: photosTable.frame.maxY, width: 100, height: 50);
        clearButton.setTitle("Clear", for: .normal);
        clearButton.setTitleColor(.black, for: .normal);
        clearButton.backgroundColor = .lightGray;
        clearButton.addTarget(self, action: #selector(self.clearButtonClicked), for: .touchUpInside);
        
        self.view.addSubview(photosTable);
        self.view.addSubview(saveButton);
        self.view.addSubview(clearButton);
        
    }
    
    func updateUIBasedOnPhotos(names:[String]) {
        self.photosTable.reloadData();
    }
    
    func getObservable() -> Observable<String> {
        let obsvble = Observable<String>.create{ observer in
            DispatchQueue.global(qos: .background).async {
                if ( self.value % 2 == 0 ) {
                    observer.onNext("Value is even");
                }else {
                    observer.onNext("Value is Odd");
                }
            }
            return Disposables.create();
        }
        return obsvble;
    }
    
    @objc func saveButtonClicked() {
        let name = Int.random(in: 0...50);
        //names.onNext("New Name");
        names.accept(names.value + ["name is \(name)"]);
        
        self.getObservable().subscribe( onNext:{
            print("Emitted value is", $0);
        }).disposed(by: disposeBag);
    }
    
    @objc func clearButtonClicked() {
        self.photoDelegate?.photosClearButtonClicked();
        names.accept(["Raju","Ravi"]);
        //names.onNext("");
        //self.dismiss(animated: true, completion: nil);
    }
    
    
    
    //MARK:- UITableView data source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.value.count;
        //return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell");
        if ( cell == nil ) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        cell?.textLabel?.text = names.value[indexPath.row];
        return cell!;
    }
}

