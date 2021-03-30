//
//  PhotoCollectionViewCell.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func bindData(photo: Photo) {
        imageView.load(url: photo.url!)
        titleLabel.text = photo.title
        tagLabel.text = "\(photo.tag ?? Tag.UNDEFINED)"
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
