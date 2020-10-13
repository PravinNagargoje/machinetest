//
//  MovieService.swift
//  exceptionairetest
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import Realm

protocol MovieServiceDelegate {    
    func didFetch(movies: Array<MovieData>)
    func didOccurError(error: String)
}

var dataModel = [MovieData]()

struct MovieService {
    
    var delegate: MovieServiceDelegate?
    let realm = try! Realm()
    
    func getData() {
       
        let dataUrl = "https://api.androidhive.info/json/movies.json"
        
        let enhancedUrl = dataUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(enhancedUrl!, method:.get, parameters:nil, encoding:JSONEncoding.default, headers:nil).responseJSON(completionHandler: {  (response) in
            
            switch response.result {
            case .success:
                
                guard let jsonArray = response.value as? NSArray else {
                    print("ERROR IN CONVERTING JSON  DATA")
                    return
                }
                
                dataModel.removeAll()
                for singleJSON in jsonArray {
                    let dictionaryJSONHistory = singleJSON as! [String:Any]
                    let singleDataModel = MovieData()
                    
                    singleDataModel.title =  "\(dictionaryJSONHistory["title"] ?? "")"
                    singleDataModel.poster = "\(dictionaryJSONHistory["image"] ?? "")"
                    singleDataModel.averageVote = "\(dictionaryJSONHistory["rating"] ?? "")"
                    singleDataModel.releaseDate = "\(dictionaryJSONHistory["releaseYear"] ?? "")"
                    singleDataModel.genre = dictionaryJSONHistory["genre"] as? [String]
                    
                    dataModel.append(singleDataModel)
                }
                
                do {
                    try self.realm.write {
                      self.realm.add(dataModel, update: .all)
                    }
                } catch(_) {
                    print("Databse error")
                }
                
                self.delegate?.didFetch(movies: dataModel)
                
                break
                
            case .failure( _) :
                self.delegate?.didOccurError(error: "No Internet Connection")
                
                break
            }
        })
    }
}
