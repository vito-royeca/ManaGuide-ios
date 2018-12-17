//
//  SearchModeTableViewCell.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 04.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import ManaKit
import PromiseKit

class SearchModeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SearchModeCell"
    
    // MARK: Variables
    var mode: ViewModelMode! {
        didSet {
            guard let cardArt = mode.cardArt else {
                return
            }
            
            let objectFinder = ["name": cardArt["name"],
                                "set.code": cardArt["setCode"],
                                "language.code": "en"] as [String: AnyObject]
            guard let card = ManaKit.sharedInstance.findObject("CMCard",
                                                               objectFinder: objectFinder,
                                                               createIfNotFound: false) as? CMCard else {
                return
            }
            
            messageLabel.text = self.mode.description
            if let croppedImage = ManaKit.sharedInstance.cardImage(card,
                                                                   imageType: .artCrop,
                                                                   faceOrder: 0,
                                                                   roundCornered: false) {
                backgroundImage.image = croppedImage
                MGUtilities.updateColor(ofLabel: messageLabel, from: croppedImage)
            } else {
                backgroundImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
                
                firstly {
                    ManaKit.sharedInstance.downloadImage(ofCard: card,
                                                         imageType: .artCrop,
                                                         faceOrder: 0)
                }.done {
                    guard let image = ManaKit.sharedInstance.cardImage(card,
                                                                       imageType: .artCrop,
                                                                       faceOrder: 0,
                                                                       roundCornered: false) else {
                        return
                    }
                    
                    let animations = {
                        self.backgroundImage.image = image
                    }
                    UIView.transition(with: self.backgroundImage,
                                      duration: 1.0,
                                      options: .transitionCrossDissolve,
                                      animations: animations,
                                      completion: nil)
                    MGUtilities.updateColor(ofLabel: self.messageLabel, from: image)
                }.catch { error in
                        
                }
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        backgroundImage.layer.cornerRadius = 10
    }
}
