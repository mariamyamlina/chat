//
//  DateFormatter.swift
//  Chat
//
//  Created by Maria Myamlina on 12.10.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

func dateFormatter(date: Date, force onlyTime: Bool) -> String {
    let formatter = DateFormatter()
    if isToday(date: date) || onlyTime {
        formatter.dateFormat = "HH:mm"
    } else {
        formatter.dateFormat = "dd MMM"
    }
    return formatter.string(from: date)
}

func isToday(date: Date) -> Bool {
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date) == formatter.string(from: today)
}
