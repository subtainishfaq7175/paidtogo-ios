//
//  DefaultNotification.swifts
//  Paid to Go
//
//  Created by MacbookPro on 29/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

class Pool {
    
    var imageUrl: String
    var text: String
    
    //    var followers:[User]
    
    
    init () {
        
        self.text = ""
        self.imageUrl = ""
        //        self.followers = [User]()
        
    }
    
    init (text: String, imageUrl: String) {
        
        self.text = text
        self.imageUrl = imageUrl
        //        self.followers = [User]()
        
    }
}