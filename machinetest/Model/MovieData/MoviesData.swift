//
//  MoviesData.swift
//  exceptionairetest
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class MovieData: Object {
   
    @objc dynamic var title : String?
    @objc dynamic var releaseDate : String?
    @objc dynamic var poster : String?
    @objc dynamic var averageVote : String?
    var genre : [String]?
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
}
