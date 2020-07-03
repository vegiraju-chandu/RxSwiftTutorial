//
//  FilterTableView.swift
//  ReactSwift
//
//  Created by Raju on 04/06/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import UIKit

struct PersonData {
    var name:String;
    var age:Double;
}


class FilterTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, WithoutRX {
    
    var inputTextField: UITextField!;
    var filterSwitch: UISwitch!;
    var dataTableView: UITableView!;
    var personInfo = [PersonData]();
    var filteredData = [PersonData]();
    
    @objc var userInputString = "";
    
    override func loadView() {
        super.loadView();
        self.addObserver(self, forKeyPath: #keyPath(userInputString), options: [.new,.old], context: nil);
        self.view.backgroundColor = .white;
        loadData();
        setUpUI();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let delegateObject = DelegationWithOutRX();
        delegateObject.delegate = self;
        delegateObject.callDelegate();
    }
    
    //MARK:- UI Methods
    func setUpUI() {
        
        filterSwitch = UISwitch(frame: CGRect(x: 10, y: 45, width: 50, height: 50));
        filterSwitch.addTarget(self, action: #selector(self.filterSwitchStateChanged(fSwitch:)), for: .valueChanged);
        
        inputTextField = UITextField(frame: CGRect(x: 10, y: filterSwitch.frame.maxY + 10, width: self.view.bounds.size.width - 20, height: 50));
        inputTextField.layer.borderColor = UIColor.black.cgColor;
        inputTextField.layer.borderWidth = 1.0;
        inputTextField.addTarget(self, action:#selector(self.inputTextChanged(textField:)) , for: .editingChanged);
        
        dataTableView = UITableView(frame: CGRect(x: 10, y: inputTextField.frame.maxY + 10, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height - inputTextField.frame.maxY + 10), style: .plain);
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.tableFooterView = UIView(frame: .zero);
        
        self.view.addSubview(inputTextField);
        self.view.addSubview(filterSwitch);
        self.view.addSubview(dataTableView);
    }
    
    func loadData() {
        for i in 0 ..< 50 {
            let person = PersonData(name: "Name \(i)", age: Double ( i * Int.random(in: 1...10)));
            personInfo.append(person);
        }
        filteredData = personInfo;
    }
    
    @objc func inputTextChanged(textField:UITextField) {
        guard let newInput = textField.text else {
            return;
        }
        setValue(newInput, forKey: "userInputString")
    }
    
    //MARK:- UITableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK:- UITableview Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell");
        if ( cell == nil ) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell");
        }
        let person = filteredData[indexPath.row];
        cell?.textLabel?.text = person.name;
        cell?.detailTextLabel?.text = "\(person.age)";
        return cell!;
    }
    //MARK:- User Defined Methods
    @objc func filterSwitchStateChanged(fSwitch: UISwitch) {
        if ( fSwitch.isOn ) {
            
        }
    }
    //MARK:- Delegate Methods
    func executeABC() {
        print("Delegate method executed");
    }
    //MARK:- KeyValueObserver Delegate Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ( keyPath == "userInputString" ) {
            if let newInputValue = change?[NSKeyValueChangeKey.newKey] as? String {
                filteredData = personInfo.filter { user in
                    user.name.lowercased().contains(newInputValue.lowercased());
                }
                dataTableView.reloadData();
            }
        }
    }
}

protocol WithoutRX:class {
    func executeABC();
}

class DelegationWithOutRX {
    weak var delegate:WithoutRX? = nil;
    func callDelegate() {
        if self.delegate != nil {
            self.delegate?.executeABC();
        }
    }
}

import RxSwift
import RxCocoa

class ReactiveFilterTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var inputTextField: UITextField!;
    var dataTableView: UITableView!;
    var personInfo   = BehaviorRelay<[PersonData]>(value: []);
    var filteredData = BehaviorRelay<[PersonData]>(value: []);
    var fSwitch = UISwitch();
    var inputValue = BehaviorRelay<Int>(value: 0);
    
    override func loadView() {
        super.loadView();
        self.view.backgroundColor = .white;
        loadData();
        setUpUI();
        
    
        let variableValue = BehaviorRelay(value: "");
        
        variableValue.subscribe( onNext:{ value in print("new value is \(value)") } );
        
        inputValue.subscribe(onNext: { (newValue) in
            print("new value is \(newValue)");
        });
    
        inputTextField.rx.text.subscribe(onNext: { (newValue) in
            print("text new value is \(newValue)");
        });
        
        Observable.combineLatest(inputTextField.rx.text, personInfo.asObservable(), resultSelector: { inputText,personsValues in
            
            guard let userInputtedText = inputText else {
                return
            }
            
            let filteredArray = personsValues.filter { (person) in
                return person.name.lowercased().contains(userInputtedText.lowercased());
            }
            self.filteredData.accept(filteredArray);
            self.dataTableView.reloadData();
        }).subscribe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let dwR = DelegationWithRX();
        dwR.nameRX.subscribe(onNext:{ event in print("new value is \(event)") } );
        dwR.callDelegate();
        
        createObservables();
        
    }
    
    func createObservables() {
        var a:Int = 10;
        let observer = Observable.just(a);
        observer.subscribe(onNext:{ value in print("new observable value is \(value)") });
        
        a = 20;
    }
    
    //MARK:- UI Methods
    func setUpUI() {
        
        inputTextField = UITextField(frame: CGRect(x: 10, y: 45, width: self.view.bounds.size.width - 20, height: 50));
        inputTextField.layer.borderColor = UIColor.black.cgColor;
        inputTextField.layer.borderWidth = 1.0;
        
        dataTableView = UITableView(frame: CGRect(x: 10, y: inputTextField.frame.maxY + 10, width: self.view.bounds.size.width - 20, height: self.view.bounds.size.height - inputTextField.frame.maxY + 10), style: .plain);
        dataTableView.delegate = self;
        dataTableView.dataSource = self;
        dataTableView.tableFooterView = UIView(frame: .zero);
        
        self.view.addSubview(inputTextField);
        self.view.addSubview(dataTableView);
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .microseconds(100)) {
            self.inputValue.accept(100);
        }
    }
    
    func loadData() {
        
        var personsArray = [PersonData]();
        for i in 0 ..< 50 {
            let person = PersonData(name: "Name \(i)", age: Double ( i * Int.random(in: 1...10)));
            personsArray.append(person);
        }
        personInfo.accept(personsArray);
        filteredData.accept(personsArray);
    }
    
    //MARK:- UITableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK:- UITableview Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.value.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell");
        if ( cell == nil ) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell");
        }
        let person = filteredData.value[indexPath.row];
        cell?.textLabel?.text = person.name;
        cell?.detailTextLabel?.text = "\(person.age)";
        return cell!;
    }
}

class DelegationWithRX {
    
    var nameRX = BehaviorRelay(value: "");
    func callDelegate() {
        nameRX.accept("Raju");
    }
}


