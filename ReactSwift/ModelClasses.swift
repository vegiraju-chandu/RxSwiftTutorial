//
//  ModelClasses.swift
//  ReactSwift
//
//  Created by Raju on 25/06/20.
//  Copyright © 2020 com.raju.coredata. All rights reserved.
//

import Foundation
import UIKit

struct MainData:Codable {
    var meta:Meta?;
    init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self);
           self.meta = try values.decode(Meta.self,forKey:.meta);
    }
}

struct Meta: Codable {
    var view:View?;
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self);
        self.view = try values.decode(View.self,forKey:.view);
    }
}

struct View: Codable  {
    var columns: [Columns]?;
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self);
        self.columns = try values.decode([Columns].self,forKey:.columns);
    }
    
}

struct Columns: Codable {
    
    var id: Int?;
    var name: String?;
    var dataTypeName: String?;
    var fieldName: String?;
    var position: Int?;
    var renderTypeName: String?;
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id         = try values.decode(Int.self, forKey:.id);
        self.name = try values.decode(String.self, forKey: .name)
        self.dataTypeName = try values.decode(String.self, forKey: .dataTypeName)
        self.fieldName = try values.decode(String.self, forKey: .fieldName)
        self.position = try values.decode(Int.self, forKey: .position)
        self.renderTypeName = try values.decode(String.self, forKey:.renderTypeName);
    }
    
}

