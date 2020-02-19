//
//  ItemCell.swift
//  CryptoDemo
//
//  Created by Igor Khomich on 11.02.2020.
//  Copyright © 2020 Igor Khomich. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UICollectionViewCell {
    public static let reuseCellIdentifier = "backup.item.cell"
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
        
    func imageLoaded(_ image: UIImage){
        DispatchQueue.main.async {
            self.imageView.image = image
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.imageView.image = nil
            self.loadingIndicator.startAnimating()
        }
    }
}
