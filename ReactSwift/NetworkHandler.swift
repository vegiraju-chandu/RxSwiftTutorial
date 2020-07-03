//
//  NetworkHandler.swift
//  ReactSwift
//
//  Created by Raju on 25/06/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum error {
    case UN_FORMATTEDURL
    case DATANOTFOUND
    case NO_NOTWORK
}

class Network {
    
    class func getApiCallWithRequestString(requestString:String,completionBlock:@escaping((_ response:Data) -> Void), failureBlock:@escaping((_ error: error)->Void)) {
    
        guard let url = URL(string: requestString) else {
            failureBlock(.UN_FORMATTEDURL);
            return;
        }
    
        let dataTask = URLSession.shared.dataTask(with: url) { (responseData, httpResponse, error) in
            if ( error == nil ) {
                if ( responseData == nil || responseData?.count == 0 ) {
                    failureBlock(.DATANOTFOUND);
                }else {
                    completionBlock(responseData!);
                }
            }else {
                failureBlock(.DATANOTFOUND);
            }
        }
        dataTask.resume();
    }
}
