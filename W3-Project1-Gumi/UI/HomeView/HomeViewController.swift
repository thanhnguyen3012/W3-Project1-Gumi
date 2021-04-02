//
//  HomeViewController.swift
//  W3-Project1-Gumi
//
//  Created by Thành Nguyên on 30/03/2021.
//

import UIKit

class HomeViewController: UIViewController {

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
        tagsCollectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.allowsMultipleSelection = true
        
        photosCollectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        photosCollectionView.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
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
                var counter = listOfTagFilter.count
                for i in listOfTagFilter {
                    if countItemsForTag(tag: i, inList: listOfPhoto) == 0 {
                        counter -= 1
                    }
                }
                return counter
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
                    let counter = countItemsForTag(tag: listOfTagFilter[i], inList: listOfPhoto)
                    if (section == i) && (counter > 0) {
                        return counter
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
                cell.isSelected = true
                cell.toggleSelected()
                cell.isExclusiveTouch = false
                cell.bindData(tag: "\(Tag.init(rawValue: listOfTagFilter[indexPath.row - 2]) ?? Tag.UNDEFINED)")
            }
            return cell
        default: // photoCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
            if indexPath.section == 0 { //((listOfTagFilter.isEmpty) || (indexPath.section == 0)) {
                cell.bindData(photo: listOfPhoto[indexPath.row])
                return cell
            } else {
                var index = 0
                for i in 0..<(listOfTagFilter.count - 1) {
                    index += countItemsForTag(tag: listOfTagFilter[i], inList: listOfPhoto)
                }
                cell.bindData(photo: listOfPhoto[indexPath.row + index])
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
        sectionHeader.backgroundColor = .systemBlue
        sectionHeader.label.text = listOfTagFilter.isEmpty ? "All" : "\(Tag(rawValue: listOfTagFilter[indexPath.section])!)"
        return sectionHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
        case photosCollectionView:
            return CGSize(width: collectionView.frame.width, height: 40)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
                print("+++++++++++++++++++++++ \(indexPath)")
                cell.toggleSelected()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
                print("----------------------- \(indexPath)")
                cell.toggleSelected()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.stackView.frame.width, height: self.stackView.frame.width * 0.75)
    }
}

// MARK: - FilterDelegate
extension HomeViewController: TagsViewControllerDelegate {
    
    func tagsViewControllerDelege(_ tagsViewControllerDelegate: TagsViewController, passListOfFilter: [Int]) {
        listOfTagFilter = passListOfFilter
        
        if listOfTagFilter.isEmpty {
            listOfPhoto = listOfAllPhoto
        } else {
            listOfPhoto.removeAll()
            for tag in listOfTagFilter {
                listOfPhoto.append(contentsOf: listOfAllPhoto.filter({ ($0.tag?.rawValue == tag) }))
            }
        }
        
        photosCollectionView.reloadData()
        tagsCollectionView.reloadData()
    }
    
}

