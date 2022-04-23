//
//  HeroCardView.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 14/06/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

import ManaKit
import PromiseKit

class HeroCardView: UIView {

    // MARK: Constants
    let preEightEditionFont      = UIFont(name: "Magic:the Gathering", size: 20.0)
    let eightEditionFont         = UIFont(name: "Matrix-Bold", size: 20.0)
    let magic2015Font            = UIFont(name: "Beleren", size: 20.0)

    // MARK: Variables
    var card: CMCard!
    
    // MARK: Outlets
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setIcon: UILabel!
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        setIcon.layer.cornerRadius = setIcon.frame.height / 2
    }
    
    // MARK: Custom methods
    func showImage() {
        if let image = card.image(type: .artCrop,
                                  faceOrder: 0,
                                  roundCornered: false) {
            cropImage.image = image
            MGUtilities.updateColor(ofLabel: nameLabel, from: image)
        } else {
            cropImage.image = ManaKit.sharedInstance.imageFromFramework(imageName: .cardBackCropped)
            MGUtilities.updateColor(ofLabel: nameLabel,
                                    from: cropImage.image!)
            
            firstly {
                ManaKit.sharedInstance.downloadImage(ofCard: card,
                                                     type: .artCrop,
                                                     faceOrder: 0)
            }.done {
                guard let image = self.card.image(type: .artCrop,
                                                  faceOrder: 0,
                                                  roundCornered: false) else {
                    return
                }
                
                let animations = {
                    self.cropImage.image = image
                }
                UIView.transition(with: self.cropImage,
                                  duration: 1.0,
                                  options: .transitionCrossDissolve,
                                  animations: animations,
                                  completion: nil)
                MGUtilities.updateColor(ofLabel: self.nameLabel, from: image)
                
            }.catch { error in
                print("\(error)")
            }
        }
    }
    
    func showNameAndSet() {
        nameLabel.text = card.name
        
        if let releaseDate = card.set!.releaseDate {
            let isModern = card.isModern()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let m15Date = formatter.date(from: "2014-07-18"),
                let setReleaseDate = formatter.date(from: releaseDate) {
                
                if setReleaseDate.compare(m15Date) == .orderedSame ||
                    setReleaseDate.compare(m15Date) == .orderedDescending {
                    nameLabel.font = magic2015Font
                    
                } else {
                    nameLabel.font = isModern ? eightEditionFont : preEightEditionFont
                }
            }
        }
        
        if let set = card.set {
            setIcon.text = set.keyruneUnicode()
            setIcon.textColor = card.keyruneColor()
            setIcon.backgroundColor = UIColor.white
        }
    }
    
    func hideNameAndSet() {
        nameLabel.text = ""
        setIcon.text = ""
        setIcon.backgroundColor = UIColor.clear
    }
}


