//
//  Date + Extension.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

extension Date {
    func dateFormatter(onlyTimeMode timeMode: Bool) -> String {
        let formatter = DateFormatter()
        if self.isToday() || timeMode {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        return formatter.string(from: self)
    }

    func isToday() -> Bool {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self) == formatter.string(from: today)
    }
}
