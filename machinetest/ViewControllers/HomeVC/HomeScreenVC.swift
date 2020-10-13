//
//  HomeScreenVC.swift
//  exceptionairetest
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class HomeScreenVC: UIViewController {

    var homePageVM: HomePageViewModel!
    var activityIndicator = UIActivityIndicatorView()
    var viewTitle = "Movies"
    var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homePageVM = HomePageViewModel(homePageVC: self)
        self.view.backgroundColor = UIColor.gray
        
        setupTableView()
        setupActivityIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        self.title = viewTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        self.title = ""
    }
}

// Mark:- NavigationRightBarButton
extension HomeScreenVC {
    func reloadTableView() {
         UIView.animate(
             withDuration: 0.8,
             delay: 0,
             usingSpringWithDamping: 1,
             initialSpringVelocity: 1,
             options: .curveEaseIn,
             animations:
             {
                 if let cView = self.tableView {
                     cView.reloadData()
                 }
                self.view.layoutIfNeeded()
         })

         self.activityIndicator.stopAnimating()
     }
    
    func setupActivityIndicator() {
        self.tableView.addSubview(self.activityIndicator)
        self.activityIndicator.style = UIActivityIndicatorView.Style.large
        self.activityIndicator.color = UIColor.white
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        self.activityIndicator.startAnimating()
    }
    
    func errorOccured(error: String) {
        self.activityIndicator.stopAnimating()
        let alert = UIAlertController(title:"Alert!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// Mark:- UITableView

extension HomeScreenVC {
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: "customCell"
        )
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = UIColor.gray
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        self.view.addSubview(self.tableView)
        
        let constraints : [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.homePageVM.fetchPopularMoviesData()
        self.refreshControl.endRefreshing()
    }
}

extension HomeScreenVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homePageVM.moviesCount()
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(
            withIdentifier: "customCell",
            for: indexPath
        ) as! CustomTableViewCell
        let image = UIImage(named: "acc")
        let acc = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            acc.image = image
        cell.accessoryView = acc
        cell.backgroundColor = UIColor.gray
        cell.configCell(movieData: self.homePageVM.getMoviesItem(index: indexPath.row))
            
        return cell
    }
}
