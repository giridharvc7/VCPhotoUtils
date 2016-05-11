//
//  ViewController.swift
//  recentPhotosExample
//
//  Created by Giridhar on 04/05/16.
//  Copyright © 2016 Giridhar. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,UICollectionViewDataSource
{
    let recentPhotoClass = VCPhotoUtils()
    

    var fetchedPhotos:PHFetchResult?
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var seeButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        photosCollectionView.dataSource = self;
        photosCollectionView.delegate = self;
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        
        photosCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    
        self.hideButtons()
        photosCollectionView.backgroundColor = UIColor.lightGrayColor()
    
        recentPhotoClass.observeForRecentNewPhotos
            {
                (results) in
                guard let photosResults = results
                    else
                {
                    self.photosLabel.text = "No new photos, or first time launch"
                    print("No new photos, or first time launch")
                    
                    return
                }
            
            self.photosLabel.text = "\(photosResults.count) new photos"
            print(photosResults.count)
                
                if(photosResults.count>0)
                {
                    self.showButtons()
                }
                else
                {
                    self.hideButtons()
                }
            
            self.fetchedPhotos = photosResults
            
            self.photosCollectionView.reloadData()
        }
        recentPhotoClass.startObservers()
    
    }
    
    
    func hideButtons()
    {
        self.seeButton.transform = CGAffineTransformMakeScale(0, 0)
        self.photosCollectionView.transform = CGAffineTransformMakeScale(0, 0)
    }
    
    func showButtons()
    {
        UIView.animateWithDuration(0.2, animations:
            {
                self.seeButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
                self.photosCollectionView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            })
        { (isAnimated) in
                UIView.animateWithDuration(0.15, animations: { 
                    self.seeButton.transform = CGAffineTransformIdentity
                    self.photosCollectionView.transform = CGAffineTransformIdentity
                })
        }
        
    }
    
    
    //MARK: Collection View datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let photosResults = fetchedPhotos
        else
        {
            return 0
        }
        
        return photosResults.count
        
//        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pic", forIndexPath: indexPath) as! photoCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        let manager = PHImageManager.defaultManager()
        
        
        
        manager.requestImageForAsset(fetchedPhotos![indexPath.row] as! PHAsset, targetSize: CGSizeMake (80,80), contentMode: .AspectFill, options: nil) { (image, _) in
            
            cell.photoImageView.image = image
        }
        
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func seePhotosAction(sender: AnyObject)
    {
        VCPhotoUtils().setSeenRecentPhotos(true)
        self.hideButtons()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(80, 80)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
}
