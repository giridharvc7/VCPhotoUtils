//
//  recentPhotos.swift
//  recentPhotos
//
//  Created by Giridhar on 02/05/16.
//  Copyright © 2016 Giridhar. All rights reserved.
//

import Foundation
import Photos

public class VCPhotoUtils
{
    var returnPhotosClosure: ((PHFetchResult?) -> ())?
    
    init()
    {
        //Removed NSNotificationCenter observers from here
    }
    
    //MARK: Notifications
    public func startObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(enterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(observeForeground), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    @objc func enterBackground(notification: NSNotification)
    {
        setLastOpenedDate()
    }
    
    @objc private func observeForeground()
    {
        self.returnRecentPhotos()
    }

    //MARK: NSUserDefault related
    func setLastOpenedDate()
    {
        if getLastOpenedDateTime() == nil
        {
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastOpenedDate")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        else
        {
            if hasSeenRecentPhotos()
            {
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey:"lastOpenedDate")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            
        }

    }
    
    public func getLastOpenedDateTime() -> NSDate?
    {
        guard let recentDate = NSUserDefaults.standardUserDefaults().objectForKey("lastOpenedDate") as? NSDate
            else
        {
            return nil
        }
        return recentDate
    }
    
    public func setSeenRecentPhotos(hasSeen: Bool)
    {
        NSUserDefaults.standardUserDefaults().setObject(hasSeen, forKey: "hasSeenRecentPictures")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func hasSeenRecentPhotos() -> Bool
    {
        return NSUserDefaults.standardUserDefaults().boolForKey("hasSeenRecentPictures")
    }
    
    
    
    // MARK: Functions and callbacks
    public func observeForRecentNewPhotos(photos: (results: PHFetchResult?)->())
    {
        returnPhotosClosure = photos
        self.returnRecentPhotos()
    }
    
    
    func returnRecentPhotos()
    {
        setSeenRecentPhotos(false)
        let latestPics = self.getRecentPhotos(self.getLastOpenedDateTime())
        returnPhotosClosure?(latestPics)
    }
    

    //MARK : Photo Operations
    public func getRecentPhotos(lastOpened: NSDate?) -> PHFetchResult?
    {
        
        
        let options = PHFetchOptions()
        if (lastOpened != nil)
        {
            if lastOpened!.isToday()
            {
                options.predicate = NSPredicate(format: "creationDate >= %@ && creationDate <= %@",lastOpened!,NSDate())
                return PHAsset.fetchAssetsWithMediaType(.Image, options: options)
            }
            else
            {
                return nil
            }
        }
        
        return nil
    }
    
}


//MARK: Extensions
extension NSDate
{
    func isToday() -> Bool
    {
        let cal = NSCalendar.currentCalendar()
        var components = cal.components([.Era, .Year, .Month, .Day], fromDate:NSDate())
        let today = cal.dateFromComponents(components)!
        
        components = cal.components([.Era, .Year, .Month, .Day], fromDate:self)
        let otherDate = cal.dateFromComponents(components)!
        
        if(today.isEqualToDate(otherDate))
        {
            return true
        }
        else
        {
            return false
        }
    }
}



