//
//  PhotoAlbumViewControllerProtocol.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 07/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import Foundation


protocol PhotoAlbumViewControllerDelegate: class {
    
    func likePhoto(photo: Photo)
    func deslikePhoto(photo: Photo)
}
