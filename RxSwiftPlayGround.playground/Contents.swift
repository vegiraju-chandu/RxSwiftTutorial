import UIKit
import RxSwift


let observer = Observable.of(1,2,3,4);
observer.subscribe(onNext: {
    print($0);
});


var start = 0;
func getNumber () -> Int {
    start += 1;
    return start;
}

let numbers = Observable<Int>.create { observer -> Disposable in
    let value = getNumber();
    observer.onNext(value);
    observer.onNext(value + 1);
    observer.onNext(value + 2);
    return Disposables.create();
}

let numbersShare = numbers.share();

numbersShare.subscribe(onNext: {
    //print("A");
    print($0);
})

numbersShare.subscribe(onNext: {
    //print("B");
    print($0);
})

numbersShare.subscribe(onNext: {
    //print("C");
    print($0);
})





// We have 4 different types of subjects ( which will behave like observables , Observer )

//1) Publish Subject

let publishSubject = PublishSubject<String>();
publishSubject.onNext("pBeforeValue");
publishSubject.subscribe( onNext: {
    print(#line);
    print($0)
    
});
publishSubject.subscribe( onNext: {
    print(#line);
    print($0)
});

publishSubject.onNext("pAfterValue");


let behaviourSubject = BehaviorSubject<String>(value: "");
behaviourSubject.onNext("BBeforePraveen");
behaviourSubject.onNext("bBeforeValue");
behaviourSubject.subscribe( onNext:{ print($0) });
behaviourSubject.onNext("After Value");
behaviourSubject.onCompleted();

let replaySubject = ReplaySubject<String>.create(bufferSize: 3);
replaySubject.onNext("rBefore1");
replaySubject.onNext("rBefore2");
replaySubject.onNext("rBefore3");
replaySubject.subscribe( onNext: { print($0) });
//replaySubject.onNext("rAfter");

replaySubject.subscribe( onNext: { print($0) });
replaySubject.onNext("Update value");



let vSubject = Variable<String>("name");
vSubject.value = "Ramu";

vSubject.asObservable().subscribe( onNext: {
    print("From variable");
    print($0);
});

vSubject.value = "Rahim";
    
vSubject.asObservable().subscribe( onNext: {
    print("From another subscriber");
    print($0);
})
vSubject.value = "Appala Raju";

behaviourSubject.onCompleted();
replaySubject.onCompleted();

// 1
let formatter = NumberFormatter();
formatter.numberStyle = .spellOut;

let obsvable = Observable<Int>.of(10,110,20,200,210,310).asObservable()
    .distinctUntilChanged({ (a, b) -> Bool in
        print(a,b);
        return a % b == 0 ;
        guard let aWords = formatter.string(from: a)?.components(separatedBy: " "), let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
        
        print(aWords);
        print(bWords);
        
        var aContainsB = false;
        for word in bWords {
            if ( aWords.contains(word) ) {
                aContainsB = true;
                break;
            }
        }
        return aContainsB;
        
    })
    .subscribe(onNext: {
        print($0);
    })

let fiObs = Observable<Int>.of(1,2,3,4,5,6,7);

fiObs.asObservable()
    .filter{ $0 > 3 }
    .filter{ $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0);
    })

var start = 0;
func getStartNumber() -> Int{
    start += 1;
    return start;
}

let numbersOb = Observable<Int>.create{ observer in
    let start:Int = getStartNumber();
    observer.onNext(start);
    observer.onNext(start + 1);
    observer.onNext(start + 2);
    observer.onCompleted();
    return Disposables.create();
}

numbersOb
    .share()
    .asObservable()
    .subscribe(onNext: {
        print($0);
    }, onCompleted:  {
        print("1 observer completed");
    })

numbersOb
.share()
    .asObservable()
.subscribe(onNext: {
    print($0);
},onCompleted:  {
    print("2 observer completed");
})

numbersOb
.share()
    .asObservable()
.subscribe(onNext: {
    print($0);
},onCompleted:  {
    print("3 observer completed");
})

numbersOb
.share()
    .asObservable()
.subscribe(onNext: {
    print($0);
},onCompleted:  {
    print("4th observer completed");
})

let disposeBag = DisposeBag();

var pSubject = PublishSubject<String>();
pSubject.onNext("Raju");
pSubject.subscribe( onNext:{
    print($0)
    
} ).disposed(by: disposeBag);
pSubject.onNext("Ravi");
class A {
    func subScribeP(){
        pSubject.subscribe( onNext:{print($0)} ).disposed(by: disposeBag);
    }
}

class B {
    func subScribeP(){
        pSubject.subscribe( onNext:{print($0)} ).disposed(by: disposeBag);
    }
}

let AI = A();
AI.subScribeP();
let BI = B();
BI.subScribeP();
pSubject.onNext("Three subscribers");

var bSubject = BehaviorSubject<String>(value: "RajuBehaviour");

let bSub1 = bSubject.subscribe( onNext: {
    print(#line);
    print($0);
})
bSubject.onNext("Ravi Behaviour");
bSubject.onNext("Ramu Behaviour");

let bSub2 = bSubject.subscribe( onNext: {
    print(#line);
    print($0);
});
bSubject.onNext("Hari Behaviour");*/

let rSubject = ReplaySubject<String>.create(bufferSize: 2);

rSubject.onNext("1");
rSubject.onNext("2");
rSubject.onNext("3");

//3 , 2
// 4 , 3

rSubject.subscribe(onNext: {
    // 2 , 3
    print(#line); // 5,4 , 5 , 6
    print($0);
});

rSubject.onNext("4"); // 4 , 3

rSubject.subscribe( onNext: {
    //Initial values are [1,2,3,4] so it will print 3, 4
    print(#line);
    print($0);
});
rSubject.onNext("5"); // 5 , 4
rSubject.onNext("6"); // 5, 6

// 2,3,4,3,4,5,5, 6 ,6















