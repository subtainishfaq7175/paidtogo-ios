//
//  HealthKit.swift
//  Paid to Go
//
//  Created by MacbookPro on 18/5/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import HealthKit
import SwiftDate

class HealthKit
{
    let storage = HKHealthStore()
    
    init()
    {
        checkAuthorization()
    }
    
    
    //    func recentSteps(completion: (Double, NSError?) -> () ) {}
    
    
    func checkAuthorization() -> Bool
    {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
            
            // Now we can request authorization for step count data
            storage.requestAuthorization(toShare: nil, read: steps as Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    
    func recentSteps(completion: @escaping (Double, Error?) -> () )
    {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
        let predicate = HKQuery.predicateForSamples(withStart: (Date() - 1.day) , end: Date(), options: .strictStartDate)
//        sWithStartDate((NSDate() as Date) - 1.days, endDate: NSDate() as Date, options: .none)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            guard let count = results?.count else {
                return
            }
            if count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            
            completion(steps, error)
        }
        
        storage.execute(query)
    }
}
