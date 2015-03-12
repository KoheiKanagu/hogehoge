//
//  main.swift
//  AddUUIDtoXcodePluginsInfoPlist
//
//  Created by Kohei on 2015/03/11.
//  Copyright (c) 2015年 KoheiKanagu. All rights reserved.
//

import Foundation

println("Hello, World!")

let xcodeUUID: NSString = "A16FF353-8441-459E-A50C-B071F53F51B7"
let pluginsPath: NSString = NSHomeDirectory() + "/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"

let fileList: NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(pluginsPath, error: nil)!

for value in fileList {
    let pluginFullPath: NSString = pluginsPath + (value as NSString) + "/Contents/Info.plist"

    if NSFileManager.defaultManager().fileExistsAtPath(pluginFullPath) {
        let dic: NSMutableDictionary = NSMutableDictionary(contentsOfFile: pluginFullPath)!
        let array: NSMutableArray = NSMutableArray(array: (dic.objectForKey("DVTPlugInCompatibilityUUIDs")) as NSArray)
        
        if (array.indexOfObject(xcodeUUID) == NSNotFound) {
            array.addObject(xcodeUUID)
            println("\(value) にXcode6.2のUUIDを追加")
            
            dic.setObject(array, forKey: "DVTPlugInCompatibilityUUIDs")
            dic.writeToFile(pluginFullPath, atomically: true)
        }else{
            println("\(value) はXcode6.2のUUIDは追加済み")
        }
    }
    
}