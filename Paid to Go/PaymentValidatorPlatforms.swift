//
//  PaymentValidatorPlatforms.swift
//  Doozie
//
//  Created by Fernando Ortiz on 19/9/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation

// MARK: - Validator -
let paymentValidator = PaymentValidator(url: "http://development.infinixsoft.com:3000/validate_payment")

// MARK: - Platforms -

let iOSPlatformPaymentData = IOSPlatformPaymentData(
    productID: "com.doozie.fullversion1",
    bundleID: "com.doozie.doozie"
)

let androidPlatformPaymentData = AndroidPlatformPaymentData(
    productID: "full_monthly",
    packageName: "com.doozie",
    keyObject: "AIzaSyBdJyHw5ZfUtlq986Jby2MjkECaUWhPGdM"
)