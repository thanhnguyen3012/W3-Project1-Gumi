//
//  TagsViewController.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

protocol TagsViewControllerDelegate {
    func tagsViewControllerDelege(_ tagsViewControllerDelegate: TagsViewController, passListOfFilter: [Int])
//    func passListOfFilter(tags : [Int])
}

class TagsViewController: UIViewController {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    var delegate : TagsViewControllerDelegate?
    var listOfTag = [String]()
    var choosedList = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        for tag in Tag.allCases {
            listOfTag.append("\(tag)")
            choosedList.append(false)
        }
        
        tagCollectionView.register(TagCollectionViewCell.nib, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.allowsMultipleSelection = true
        let customFlowLayout = CustomFlowLayout()
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagCollectionView.collectionViewLayout = customFlowLayout
    }

    @IBAction func addFilterButtonTapped(_ sender: Any) {
        var resultList = [Int]()
        for i in 0..<choosedList.count {
            if choosedList[i] {
                resultList.append(i)
            }
        }
//        delegate?.passListOfFilter(tags: resultList)
        delegate?.tagsViewControllerDelege(self, passListOfFilter: resultList)
        self.dismiss(animated: true, completion: nil)
    }
}

extension TagsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
        cell.bindData(tag: listOfTag[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            cell.toggleSelected()
            choosedList[indexPath.row] = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            cell.toggleSelected()
            choosedList[indexPath.row] = false
        }
    }
    
}
