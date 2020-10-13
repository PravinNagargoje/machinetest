//
//  HomePageVewModel.swift
//  exceptionairetest
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

enum SectionType {
    case movie
    case season
}
class HomePageViewModel {
    
    fileprivate var movieService = MovieService()
    fileprivate var moviesArray: Array<MovieData> = Array<MovieData>()
    fileprivate var homePageVC : HomeScreenVC!
    
    init(homePageVC: HomeScreenVC) {
        self.homePageVC = homePageVC
        self.movieService.delegate = self
        
        fetchPopularMoviesData()
    }
        
    func fetchPopularMoviesData() {
        let realm = try! Realm()
        let result = realm.objects(MovieData.self)
        if result.count > 0 {
            self.moviesArray.removeAll()
            self.moviesArray = result.map({ $0.self })
            self.homePageVC.reloadTableView()
        }
        self.movieService.getData()
    }
            
    func moviesCount() -> Int {
       return self.moviesArray.count
    }
    
    func getMoviesItem(index: Int) -> MovieData {
        return self.moviesArray[index]
    }
    
    func setTitle() -> String {
        return "Movies"
    }
    
    func getCellSpace() -> CGFloat {
        
        return 5.0
    }
}

extension HomePageViewModel: MovieServiceDelegate {
    
    func didFetch(movies: Array<MovieData>) {
        self.moviesArray.removeAll()
        self.moviesArray = movies
        self.homePageVC.reloadTableView()
    }
    
    func didOccurError(error: String) {
        self.homePageVC.errorOccured(error: error)
    }
}
