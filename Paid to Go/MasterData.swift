//
//  MasterData.swift
//  Paid to Go
//
//  Created by Razi Tiwana on 03/09/2018.
//  Copyright © 2018 Infinixsoft. All rights reserved.
//

import Foundation

public class MasterData : Codable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    var caloriesPerMile: Int?
    var stepsPerMile: Int?
    var gymCheckIn: Int?
    var co2OffsetPerMile: Double?
    var trafficPerMile: Double?
    var profit: Double?
    var speedOnFoot: Int?
    var speedOnBike: Int?
    
    enum CodingKeys: String, CodingKey {
        case caloriesPerMile
        case stepsPerMile
        case gymCheckIn
        case co2OffsetPerMile
        case profit
        case speedOnFoot
        case speedOnBike
        case trafficPerMile
    }
    
    static var sharedData: MasterData? {
        get {
            if let data = UserDefaults.standard.value(forKey: "MasterData") as? Data {
                do {
                    let sharedData = try JSONDecoder().decode(MasterData.self, from: data)
                   return sharedData
                    
                } catch {
                    print(error)
                }
            }
             return nil
        }
        
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "MasterData")
            } catch {
                print(error)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
}
