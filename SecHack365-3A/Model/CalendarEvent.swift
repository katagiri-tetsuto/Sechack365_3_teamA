//
//  CalendarEvent.swift
//  SecHack365-3A
//
//  Created by 片岡昴晴 on 2025/08/23.
//

import Foundation
import EventKit

struct CalendarEvent: Identifiable, Sendable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String?
    let notes: String?
    let isAllDay: Bool
    
    init(from ekEvent: EKEvent) {
        self.id = ekEvent.eventIdentifier
        self.title = ekEvent.title ?? "無題のイベント"
        self.startDate = ekEvent.startDate
        self.endDate = ekEvent.endDate
        self.location = ekEvent.location
        self.notes = ekEvent.notes
        self.isAllDay = ekEvent.isAllDay
    }
}

extension CalendarEvent {
    // AI解析用のテキスト情報を結合
    var analysisText: String {
        var text = title
        if let location = location, !location.isEmpty {
            text += " @\(location)"
        }
        if let notes = notes, !notes.isEmpty {
            text += " \(notes)"
        }
        return text
    }
}
