//
//  String+Extensions.swift
//  Surreal
//
//  Created by Luca Rocchi on 14/07/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

extension String {
    var localize:String {
        return NSLocalizedString(self,comment: "")
    }
}
