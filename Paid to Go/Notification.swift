//
//  DefaultNotification.swifts
//  Paid to Go
//
//  Created by MacbookPro on 29/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

class Notification {
    
    var imageUrl: String
    var detail: String
    var text: String
    var type: Int
    
    //    var followers:[User]
    
    
    init () {
        
        self.detail = ""
        self.text = ""
        self.imageUrl = ""
        self.type = 0
        //        self.followers = [User]()
        
    }
    
    init (text: String, detail: String, imageUrl: String, type: Int) {
        
        self.detail = detail
        self.text = text
        self.imageUrl = imageUrl
        self.type = type
        //        self.followers = [User]()
        
    }
}