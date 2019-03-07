//
//  FlickrCell.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 03/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import UIKit

class FlickrCell: UICollectionViewCell {
    
    var photo: Photo? {
        didSet {
            guard let image = UIImage(named: (photo?.name)!) else {
                return
            }
            imageView.image = image
        }
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "deslikePhoto"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellLayout()
    }
    
    private func setupCellLayout() {
        addSubview(imageView)
        addSubview(likeButton)
        NSLayoutConstraint.activate([
            
            // Setting the imageView constraints
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Setting the like button constraints
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: like / dislike photo
    func shouldLikePhoto(_ like: Bool, photo: Photo) {
        let image = like ? UIImage(named: "deslikePhoto") : UIImage(named: "deslikePhoto")
        likeButton.setImage(image, for: .normal)
        //like ? delegate.likePhoto(photo: photo) : delegate.deslikePhoto(photo: photo)
    }
}
