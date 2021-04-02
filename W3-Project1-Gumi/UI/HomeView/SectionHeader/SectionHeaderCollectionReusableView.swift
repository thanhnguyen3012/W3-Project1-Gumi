//
//  SectionHeaderCollectionReusableView.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    
    var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .white
         label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
         label.sizeToFit()
         return label
     }()

     override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        
        layer.cornerRadius = 4

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
