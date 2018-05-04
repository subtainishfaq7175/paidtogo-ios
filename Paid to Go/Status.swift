//
//  Status.swift
//  Paid to Go
//
//  Created by Nahuel on 30/6/16.
//  Copyright © 2016 Infinixsoft. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftDate

enum Stats {
    case Incomes
    case SavedGas
    case CarbonOff
}

public class Status: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kStatusIncomes: String = "incomes"
    internal let kStatusSavedGas: String = "saved_gas"
    internal let kStatusCarbonOff: String = "carbon_off"
    internal let kStatusCalories: String = "calories"
    
    public var incomes: StatusType?
    public var savedGas: StatusType?
    public var carbonOff: StatusType?
    public var calories: StatusType?
    
    init() {
        
    }

    required public init?(map: Map) {
        
    }
    
    // Mappable
    public func mapping(map: Map) {
        
        incomes             <-  map[kStatusIncomes]
        savedGas            <-  map[kStatusSavedGas]
        carbonOff           <-  map[kStatusCarbonOff]
        calories            <-  map[kStatusCalories]
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        
        if incomes != nil {
            dictionary.updateValue(incomes!.dictionaryRepresentation() as AnyObject, forKey: "incomes")
        }
        
        return dictionary
    }
    
    // MARK: Methods
    
    func loadIncomesData( monthlyIncomes:inout Array<Double>, weeklyIncomes:inout [Double], currentDate:Date) {
        
        guard let incomes = self.incomes as StatusType? else {
            return
        }
        
        for incomeCalculatedUnit in incomes.calculatedUnits! {
            
            guard let dateString = incomeCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(index: dateString.count-9)
            
            guard let date = dateStringISO.date(format: DateFormat.custom("yyyy-MM-dd")) else {
                continue
            }
            
            monthlyIncomes[date.month-1] += incomeCalculatedUnit.value!
            
            // If the current day is Sunday, we show all the information of the past week
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyIncomes[dayOfTheWeek] += incomeCalculatedUnit.value!
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyIncomes[dayOfTheWeek] += incomeCalculatedUnit.value!
                }
            }
        }
    }
    
    func loadSavedGas( monthlyGasSaved:inout Array<Double>, weeklyGasSaved:inout [Double], currentDate:Date) {
        
        guard let savedGas = self.savedGas as StatusType? else {
            return
        }
        
        for savedGasCalculatedUnit in savedGas.calculatedUnits! {
            
            guard let dateString = savedGasCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(index: dateString.count-9)
            
            guard let date = dateStringISO.date(format: DateFormat.custom("yyyy-MM-dd")) else {
                continue
            }
            
            monthlyGasSaved[date.month-1] += savedGasCalculatedUnit.value!
            
            // If the current day is Sunday, we show all the information of the past week
            
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyGasSaved[dayOfTheWeek] += savedGasCalculatedUnit.value!
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyGasSaved[dayOfTheWeek] += savedGasCalculatedUnit.value!
                }
            }
        }
    }
    
    func loadCarbonOffset( monthlyCarbonOffset:inout Array<Double>, weeklyCarbonOffset:inout [Double], currentDate:Date) {
        
        guard let carbonOff = self.carbonOff as StatusType? else {
            return
        }
        
        for carbonOffCalculatedUnit in carbonOff.calculatedUnits! {
            
            guard let dateString = carbonOffCalculatedUnit.date else {
                continue
            }
            
            let dateStringISO = dateString.substringToIndex(index: dateString.count-9)
            
            guard let date = dateStringISO.date(format: DateFormat.custom("yyyy-MM-dd")) else {
                continue
            }
            
            monthlyCarbonOffset[date.month-1] += carbonOffCalculatedUnit.value!
            
            // If the current day is Sunday, we show all the information of the past week
            if currentDate.weekday == 1 {
                if currentDate.weekOfYear-1 == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyCarbonOffset[dayOfTheWeek] += carbonOffCalculatedUnit.value!
                }
                
            } else {
                // If weeks of the year match -> Monday to Saturday
                if currentDate.weekOfYear == date.weekOfYear {
                    
                    // Sunday -> date.weekday == 1
                    let dayOfTheWeek = date.weekday-1
                    
                    weeklyCarbonOffset[dayOfTheWeek] += carbonOffCalculatedUnit.value!
                }
            }
        }
    }
}
