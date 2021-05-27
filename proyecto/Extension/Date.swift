//
//  Date.swift
//  proyecto
//
//  Created by macOS on 22/4/21.
//

import Foundation
import SwiftUI

extension Date {
        func dateToStringFormatted(_ date: Date) -> String {
            let date2 = self.dateTo(date, "dd/MM/yyyy")
            let hourAndMinute = self.dateTo(date,"HH:mm")
            return "\(date2) a las \(hourAndMinute)"
        }
    
    
    func dateTo(_ date: Date, _ format : String) -> String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.calendar = .autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
        func stringToDate(_ date: String) -> String {
            let formatter = DateFormatter()
            formatter.locale = .autoupdatingCurrent
            formatter.calendar = .autoupdatingCurrent
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateToStringFormatted(formatter.date(from: date)!)
            
        }


    }


