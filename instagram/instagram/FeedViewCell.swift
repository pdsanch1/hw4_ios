//
//  FeedViewCell.swift
//  instagram
//
//  Created by Pedro Daniel Sanchez on 10/2/18.
//  Copyright © 2018 Pedro Daniel Sanchez. All rights reserved.
//

import UIKit


protocol DisplayInfoAction: class {
    func displayInfo(title: String, message: String)
}


class FeedViewCell: UITableViewCell {

    var displayInfoDelegate: DisplayInfoAction?
    var dateCreated: Date!
    var likes: Int!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var descriptionImageView: UILabel!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBAction func onMoreInfoAction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        displayInfoDelegate?.displayInfo(title: "Information", message: "Date Created: \(dateFormatter.string(from: dateCreated!)) \n Likes: \(likes!)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        moreInfoButton.backgroundColor = .clear
        moreInfoButton.layer.cornerRadius = 5
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.brown.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
