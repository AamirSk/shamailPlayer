//
//  MediaTableViewCell.swift
//  MyMediaPlayer
//
//  Created by Ameer Shaikh on 05/07/2020.
//  Copyright © 2020 SAED. All rights reserved.
//

import UIKit
import SDWebImage

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var mediaTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(imageUrl:String) {
        let imageURL = URL(string: imageUrl)
        self.mediaImage.sd_imageIndicator?.startAnimatingIndicator()
        self.mediaImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.mediaImage.sd_setImage(with: imageURL)
        }

}
