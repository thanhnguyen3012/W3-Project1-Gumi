//
//  HomeViewController.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

class HomeViewController: UIViewController, FilterDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIButton!
    
    
    let listOfSortFilter = ["A → Z", "Z → A"]
    var listOfTagFilter = [Int]()
    var listOfAllPhoto = [ Photo(url: "https://picsum.photos/id/0/5616/3744", title: "Alejandro Escamilla", tag: Tag.ART),
                        Photo(url: "https://picsum.photos/id/1/5616/3744", title: "Alejandro Escamilla", tag: Tag.NATURAL),
                        Photo(url: "https://picsum.photos/id/100/2500/1656", title: "Tina Rataj", tag: Tag.ART)]
    var listOfPhoto = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        listOfPhoto = listOfAllPhoto
        
        tagsCollectionView.register(TagCollectionViewCell.nib, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        photosCollectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
    
    func passListOfFilter(tags: [Int]) {
        listOfTagFilter = tags
        
        if listOfTagFilter.isEmpty {
            listOfPhoto = listOfAllPhoto
        } else {
            listOfPhoto.removeAll()
            for i in listOfTagFilter {
                for photo in listOfAllPhoto {
                    if Tag(rawValue: i) == photo.tag {
                        listOfPhoto.append(photo)
                    }
                }
            }
        }
        
        photosCollectionView.reloadData()
        tagsCollectionView.reloadData()
    }
    
    @IBAction func showFiltersView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TagsView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tagsViewController") as! TagsViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func countItemsForTag(tag: Int, inList: [Photo]) -> Int { // Counting in listOfPhoto[]
        var counter = 0
        for photo in inList {
            if photo.tag == Tag(rawValue: tag){
                counter += 1
            }
        }
        return counter
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case tagsCollectionView:
            return 1
        default:
            if listOfTagFilter.isEmpty {
                return 1
            } else {
                return listOfTagFilter.count
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case tagsCollectionView:
            return listOfSortFilter.count + listOfTagFilter.count
        default: // photosCollectionView
            if listOfTagFilter.isEmpty {
                return listOfPhoto.count
            } else {
                //Return Number of item in section
                for i in 0..<listOfTagFilter.count {
                    if section == i {
                        return countItemsForTag(tag: listOfTagFilter[i], inList: listOfPhoto)
                    }
                }
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case tagsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            if indexPath.row < 2 {
                cell.bindData(tag: listOfSortFilter[indexPath.row])
            } else {
                cell.bindData(tag: "\(Tag.init(rawValue: listOfTagFilter[indexPath.row - 2]) ?? Tag.UNDEFINED)")
            }
            return cell
        default: // photoCollectionView
            print("*****************  Section:\(indexPath.section)    Row:\(indexPath.row)")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
            cell.bindData(photo: listOfPhoto[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case photosCollectionView:
            <#code#>
        default:
            return UICollectionReusableView()
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == tagsCollectionView {
//            if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
//                cell.toggleSelected()
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == tagsCollectionView {
//            if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
//                cell.toggleSelected()
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.stackView.frame.width, height: self.stackView.frame.width * 0.75)
    }
}

protocol FilterDelegate {
    func passListOfFilter(tags : [Int])
}
