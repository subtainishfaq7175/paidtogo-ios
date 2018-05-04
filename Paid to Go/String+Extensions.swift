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
//        return self.substringFromIndex(index: self.startIndex.advanced(by: index))
        return self.substringFromIndex(index:index)
    }
    
    func substringToIndex(index: Int) -> String
    {
        if (index < 0 || index > self.characters.count)
        {
            print("index \(index) out of bounds")
            return ""
        }
//        return self.substringToIndex(index: self.startIndex.advanced(by: index))
        return self.substringToIndex(index:index)
    }
}
