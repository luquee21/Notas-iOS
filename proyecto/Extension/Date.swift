//
//  Date.swift
//  proyecto
//
//  Created by macOS on 22/4/21.
//

import Foundation


extension Date {
    func timeAgoDisplay() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.zeroFormattingBehavior = .dropAll
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
    
    
    func localTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
        
    }
}
