//
//  ColumnFlowLayout.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 04/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import Foundation
import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 100, height: 100)
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        sectionInset = UIEdgeInsets(top: minimumLineSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        sectionInsetReference = .fromSafeArea
    }
}
