//
//  DateaHelper.swift
//  GivBit
//
//  Created by Tallal Javed on 6/8/18.
//  Copyright © 2018 Ibtidah. All rights reserved.
//

import UIKit

class DateaHelper: NSObject {
    
    // timeinterval since string in format X days ago, X weeks ago, X months ago X years ago. The time interval should be in unix, since 1970
    static func getTimeSinceStringFrom(timeInterval: TimeInterval) -> String{
        let givenDate = Date(timeIntervalSince1970: timeInterval)
        let currentDate = Date()
        let calendar = Calendar.current
        let d1 = calendar.startOfDay(for: givenDate)
        let d2 = calendar.startOfDay(for: currentDate)
        let differenceOfDays = calendar.dateComponents([.day], from: d1, to: d2)
        let day = differenceOfDays.day!
        
        if day < 1{
            return "Today"
        }
        if day < 2{
            return String(format: "%d day ago", day)
        }
        if day < 30{
            return String(format: "%d days ago", day)
        }
        // months
        if day/30 < 2{
            return String(format: "%d month ago", day/30)
        }
        if day/30 < 12{
            return String(format: "%d months ago", day/30)
        }
        // years
        if day/30 > 11 && day/30 < 24{
            return String(format: "1 year ago")
        }
        if day/30 > 24 {
            return String(format: "%d years ago", day/30)
        }
        return ""
    }
}
