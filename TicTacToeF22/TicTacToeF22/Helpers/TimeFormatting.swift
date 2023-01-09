//
//  TimeFormatting.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 04.01.2023.
//

import Foundation

func calcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120 && minutes % 10 == 1 {
        return "\(minutes) minute ago"
    } else if minutes < 120 {
        return "\(minutes) minutes ago"
    } else if minutes >= 120 && hours < 48 {
        return "\(hours) hours ago"
    } else {
        return "\(days) days ago"
    }
}
