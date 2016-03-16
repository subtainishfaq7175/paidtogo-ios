//
//  String+Localize.swift
//  Paid to Go
//
//  Created by MacbookPro on 16/3/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}