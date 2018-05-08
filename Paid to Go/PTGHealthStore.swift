//
//  PTGHealthStore.swift
//  Paid to Go
//
//  Created by Shamshir Ali on 08/05/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//
import HealthKitUI
import Foundation
class PTGHealthStore {
//    Singalton implementation
    static let healthStoreShared = PTGHealthStore()
    var allTypes = Set<HKObjectType>()
    private init() {
        
    }
   
    let healthStore = HKHealthStore()
    var viewController:UIViewController?
    func setVC(_ vc:UIViewController)  {
        viewController = vc
    }
    // Health store avaiablity check
    func isHealthDataAvaiable() -> Bool {
        if HKHealthStore.isHealthDataAvailable(){
            print("Congratulations heath store available")
            return true
        }else {
            print("sorry heath store unavailable")
            AppUtils.utilsShared.showAlert(viewController, message: "Sorry heath store is unavailable !!!", type: .simpleMessge, title: Constants.consShared.APP_NAME, btnTitle:Constants.consShared.OK_STR )
            return false
        }
    }
//    heathkit configurations and premission requests
    //    MARK: - Configurations
    func permissionRequest()  {
        allTypes = Set([HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
            ])
        healthStore.requestAuthorization(toShare: allTypes as? Set<HKSampleType>, read: allTypes) { (isSuccess, error) in
        if isSuccess {
        print("permissions granted")
        }
        if let error = error{
            AppUtils.utilsShared.showAlert(self.viewController, message: error.localizedDescription)
        }
        }
    }
    func configHealthKit()  {
         permissionRequest()
        guard   let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let cycling = HKObjectType.quantityType(forIdentifier: .distanceCycling),
            let walkAndRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)else {

                //                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        let workout = HKObjectType.workoutType()
        getTodayseWorkouts { (workout, error) in
            print("Workout: \(workout) error : \(error)")

        }
        let types:[HKObjectType] = [stepCount,cycling,walkAndRunning]
        for type in types {
            getTodaysData(type: type, completion: { ( data, error) in
                if let err = error{
                    AppUtils.utilsShared.showAlert(self.viewController, message:  err.localizedDescription)
                }
                switch type {
                case stepCount:
                    print("Steps: \(data) error : \(error)")
                    break
                case walkAndRunning:
                    print("Walk: \(data) error : \(error)")
                    break
                case cycling:
                    print("Cycling: \(data) error : \(error)")
                    break
                default:
                    break
                }
            })
        }
        
    }
    func getTodaysData(type : HKObjectType, completion: @escaping (Double,Error?) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let query = HKStatisticsQuery(quantityType:type as! HKQuantityType , quantitySamplePredicate: HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate), options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0,error)
                return
            }
            
            DispatchQueue.main.async {
                if type == HKQuantityType.quantityType(forIdentifier: .stepCount)! {
                    completion(sum.doubleValue(for: HKUnit.count()), nil)

                }
                else {
                    completion(sum.doubleValue(for: HKUnit.mile()), nil)

                }
            }
        }
        
        healthStore.execute(query)
    }
    func getTodayseWorkouts(completion: @escaping (([HKWorkout]?, Error?) -> Swift.Void)){
        
        //1. Get all workouts with the "Other" activity type.
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .other)
        
        //2. Get all workouts that only came from this app.
        let sourcePredicate = HKQuery.predicateForObjects(from: HKSource.default())
        
        //3. Combine the predicates into a single predicate.
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [workoutPredicate,
                                                                           sourcePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                  predicate: compound,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                                    
                                    DispatchQueue.main.async {
                                        
                                        //4. Cast the samples as HKWorkout
                                        guard let samples = samples as? [HKWorkout],
                                            error == nil else {
                                                completion(nil, error)
                                                return
                                        }
                                        
                                        completion(samples, nil)
                                    }
        }
        
        HKHealthStore().execute(query)
    }
//    func getTodaysWorkout(completion: @escaping (Double,Error?) -> Void) {
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let query = HKStatisticsQuery(quantityType: HKQuantityType.workoutType(), quantitySamplePredicate: HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate), options: .cumulativeSum) { (_, result, error) in
//            guard let result = result, let sum = result.sumQuantity() else {
//                log.error("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
//                completion(0.0,error)
//                return
//            }
//
//            DispatchQueue.main.async {
//                completion(sum.doubleValue(for: HKUnit.count()), nil)
//            }
//        }
//
//        healthStore.execute(query)
//    }
}
