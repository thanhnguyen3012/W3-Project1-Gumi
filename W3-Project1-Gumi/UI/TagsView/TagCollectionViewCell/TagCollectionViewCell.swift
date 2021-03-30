//
//  TagCollectionViewCell.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius =  (self.frame.height / 2) - 5
        self.toggleSelected()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func toggleSelected() {
        if (isSelected){
            contentView.backgroundColor = .systemBlue
            tagLabel.textColor = .white
        } else {
            contentView.backgroundColor = .systemGray5
            tagLabel.textColor = .black
        }
    }
    
    func bindData(tag: String) {
        tagLabel.text = tag
        tagLabel.sizeToFit()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

}
