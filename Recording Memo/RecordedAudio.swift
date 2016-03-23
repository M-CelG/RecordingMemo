//
//  RecordedAudio.swift
//  Recording Memo
//
//  Created by Manish Sharma on 6/22/15.
//  Copyright (c) 2015 CelG Mobile LLC. All rights reserved.
//

import Foundation


class RecordedAudio: NSObject {
    
    var title: String
    var filePathURL: NSURL
    
    init (title: String, filePathURL: NSURL) {
        self.title = title
        self.filePathURL = filePathURL
    }
    
}