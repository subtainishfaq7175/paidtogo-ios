//
//  String+Extensions.swift
//  Paid to Go
//
//  Created by Nahuel on 5/7/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension String
{
    func substringFromIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
    
    func substringToIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
}