//
//  FavPhotoCell.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 06/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit

class FavPhotoCell: UICollectionViewCell {
    
    var photo: [Photo]? {
        didSet {
            
        }
    }
    
    private var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            //Setting the imageView constraints
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
