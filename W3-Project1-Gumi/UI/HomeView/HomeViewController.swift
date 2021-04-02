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
                           Photo(url: "https://picsum.photos/id/100/2500/1656", title: "Tina Rataj", tag: Tag.ART),
                           Photo(url: "https://picsum.photos/id/100/2500/1656", title: "Tina Rataj", tag: Tag.ART),
                           Photo(url: "https://picsum.photos/id/1000/5626/3635", title: "Lukas Budimaier", tag: Tag.FOOD),
                           Photo(url: "https://picsum.photos/id/1001/5616/3744", title: "Danielle MacInnes", tag: Tag.FASHION),
                           Photo(url: "https://picsum.photos/id/1002/4312/2868", title: "NASA", tag: Tag.UNDEFINED),
                           Photo(url: "https://picsum.photos/id/1003/1181/1772", title: "E+N Photographies", tag: Tag.ANIMAL),
                           Photo(url: "https://picsum.photos/id/1004/5616/3744", title: "Greg Rakozy", tag: Tag.NATURAL),
                           Photo(url: "https://picsum.photos/id/1005/5760/3840", title: "Matthew Wiebe", tag: Tag.FOOD),
                           Photo(url: "https://picsum.photos/id/1006/3000/2000", title: "Vladimir Kudinov", tag: Tag.FASHION),
                           Photo(url: "https://picsum.photos/id/1008/5616/3744", title: "Benjamin Combs", tag: Tag.ACTIVE),
                           Photo(url: "https://picsum.photos/id/1009/5000/7502", title: "Christopher Campbell", tag: Tag.GAME),
                           Photo(url: "https://picsum.photos/id/101/2621/1747", title: "Christian Bardenhorst", tag: Tag.ANIMAL),
                           Photo(url: "https://picsum.photos/id/1010/5184/3456", title: "Samantha Sophia", tag: Tag.UNDEFINED),
                           Photo(url: "https://picsum.photos/id/1011/5472/3648", title: "Roberto Nickson", tag: Tag.PARTY),
                           Photo(url: "https://picsum.photos/id/1012/3973/2639", title: "Scott Webb", tag: Tag.PERSON),
                           Photo(url: "https://picsum.photos/id/1013/4256/2832", title: "Cayton Heath", tag: Tag.TECHNICAL),
                           Photo(url: "https://picsum.photos/id/1014/6016/4000", title: "Oscar Keys", tag: Tag.UNDEFINED),
                           Photo(url: "https://picsum.photos/id/1015/6000/4000", title: "Alexey Topolyanskiy", tag: Tag.PERSON),
                           Photo(url: "https://picsum.photos/id/1016/3844/2563", title: "Philippe Wuyts", tag: Tag.NATURAL),
                           Photo(url: "https://picsum.photos/id/1018/3914/2935", title: "Andrew Ridley", tag: Tag.ACTIVE),
                           Photo(url: "https://picsum.photos/id/1019/5472/3648", title: "Patrick Fore", tag: Tag.FOOD),
                           Photo(url: "https://picsum.photos/id/102/4320/3240", title: "Ben Moore", tag: Tag.GAME),
                           Photo(url: "https://picsum.photos/id/1020/4288/2848", title: "Adam Willoughby-Knox", tag: Tag.ACTIVE),
                           Photo(url: "https://picsum.photos/id/1021/2048/1206", title: "Frances Gunn", tag: Tag.UNDEFINED),
                           Photo(url: "https://picsum.photos/id/1022/6000/3376", title: "Vashishtha Jogi", tag: Tag.ART),
                           Photo(url: "https://picsum.photos/id/1023/3955/2094", title: "William Hook", tag: Tag.FASHION),
                           Photo(url: "https://picsum.photos/id/1024/1920/1280", title: "ÐœÐ°Ñ€Ñ‚Ð¸Ð½ Ð¢Ð°ÑÐµÐ²", tag: Tag.NATURAL),
                           Photo(url: "https://picsum.photos/id/1025/4951/3301", title: "Matthew Wiebe", tag: Tag.PERSON)]
    
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
        tagsCollectionView.allowsMultipleSelection = false
        
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
    
    func sortPhotoCollection(option: Int) { //  0: A → Z    |   1: Z → A
        switch option {
        case 0 where listOfTagFilter.isEmpty:
            print("~~~~~~~~~~~~~~~~~~~~~~~ Sort A → Z for all")
            listOfPhoto = listOfPhoto.sorted{ $0.title < $1.title }
        case 0 where !listOfTagFilter.isEmpty:
            print("~~~~~~~~~~~~~~~~~~~~~~~ Sort A → Z for filters")
            listOfPhoto = listOfPhoto.sorted{ $0.tag == $1.tag && $0.title < $1.title }
        case 1 where listOfTagFilter.isEmpty:
            print("~~~~~~~~~~~~~~~~~~~~~~~ Sort Z → A for all")
            listOfPhoto = listOfPhoto.sorted{ $0.title > $1.title }
        default:
            print("~~~~~~~~~~~~~~~~~~~~~~~ Sort Z → A for filters")
            listOfPhoto = listOfPhoto.sorted{ $0.tag == $1.tag && $0.title > $1.title }
        }
        
        photosCollectionView.reloadData()
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
                cell.isSelected = false
                cell.toggleSelected()
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
                sortPhotoCollection(option: indexPath.row)
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

