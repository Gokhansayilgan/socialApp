//
//  PostCell.swift
//  socialApp
//
//  Created by Gökhan Sayılgan on 12/05/17.
//  Copyright © 2017 Gökhan Sayılgan. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"

        if img != nil {
            self.postImg.image = img
            
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 4 * 5000 * 5000, completion: { (data, error) in
                if error != nil {
                    print("Gökhan: Unable to dowload image from Firebase storage" )
                } else {
                    print("Gökhan: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
                
                })
            }
        }
    
    
}
    
    


