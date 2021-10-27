//
//  PhotoSelectorController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 26.10.2021.
//

import Foundation
import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var header: PhotoSelectorHeader?
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .black
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.leftBarButtonItem?.tintColor = .white
        tabBarController?.tabBar.isHidden = true
        fetchPhotos()
    }
    
    fileprivate func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        fetchOptions.fetchLimit = 10
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 350, height: 350)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleNext() {
        let viewController = EditTextViewController()
        viewController.selectedImage = header?.imageView.image 
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func handleCancel() {
       dismiss(animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoSelectorCell {
          //  cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6608029801)
            selectedImage = images[indexPath.item]
           
            collectionView.reloadData()
           
            
        }
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoSelectorCell {
//            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//
//        }
//    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.bounds.width, height: view.bounds.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! PhotoSelectorHeader
        self.header = header
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 1600, height: 1600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    header.imageView.image = image
                }
            }
        }
       
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoSelectorCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 3)/4
        return CGSize(width: width, height: width)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
