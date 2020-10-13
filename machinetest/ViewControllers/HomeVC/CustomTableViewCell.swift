//
//  CustomTableViewCell.swift
//  exceptionairetest
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {

    var posterImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let ratingLabel = UILabel()
    let genreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupCustomCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(movieData: MovieData) {
        if let title = movieData.title {
            self.titleLabel.text = title
        }
        if let poster = movieData.poster,
            let url = URL(string: poster)
        {
            posterImageView.kf.indicatorType = .activity
            self.posterImageView.kf.setImage(with: url)
        }
        if let date = movieData.releaseDate {
            self.dateLabel.text = "Release Date: \(date)"
        }
        if let rating = movieData.averageVote {
            self.ratingLabel.text = "Rating: \(String(format:"%.02f", NSString(string: rating).doubleValue))"
        }
        if let genreData = movieData.genre {
            var genre = "Genre: "
            for g in genreData {
               genre = genre + "\(g), "
            }
            self.genreLabel.text = genre
        }
    }
}

extension CustomTableViewCell {
    
    func setupCustomCell(){
       
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        
        contentView.layer.cornerRadius = 7
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.gray
        
        setupLabel(label: dateLabel)
        setupLabel(label: ratingLabel)
        setupLabel(label: genreLabel)
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = UIColor.white
        
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalToConstant: 100),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            ratingLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),

            genreLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            genreLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        self.contentView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 740), for: .vertical)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 740), for: .vertical)
    }
    
    func setupLabel(label: UILabel) {
        contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
}
