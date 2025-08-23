//
//  CalendarViewModel.swift
//  SecHack365-3A
//
//  Created by 片岡昴晴 on 2025/08/23.
//

import Foundation
import EventKit

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var calendarService = CalendarService()
    @Published var selectedDate = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var events: [CalendarEvent] {
        calendarService.events
    }
    
    var authorizationStatus: EKAuthorizationStatus {
        calendarService.authorizationStatus
    }
    
    var needsAuthorization: Bool {
        authorizationStatus == .notDetermined || authorizationStatus == .denied
    }
    
    // カレンダーアクセス許可を要求
    func requestCalendarAccess() async {
        isLoading = true
        errorMessage = nil
        
        await calendarService.requestAccess()
        
        if authorizationStatus == .fullAccess {
            loadEvents()
        } else {
            errorMessage = "カレンダーアクセスが拒否されました。設定から許可してください。"
        }
        
        isLoading = false
    }
    
    // イベントを読み込み
    func loadEvents() {
        guard authorizationStatus == .fullAccess else {
            errorMessage = "カレンダーアクセスが許可されていません"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        calendarService.fetchEvents(daysAhead: 7)
        
        isLoading = false
    }
    
    // 特定の日のイベントを読み込み
    func loadEventsForDate(_ date: Date) {
        guard authorizationStatus == .fullAccess else {
            errorMessage = "カレンダーアクセスが許可されていません"
            return
        }
        
        isLoading = true
        errorMessage = nil
        selectedDate = date
        
        calendarService.fetchEventsForDate(date)
        
        isLoading = false
    }
    
    // 今日のイベントのみを取得
    var todayEvents: [CalendarEvent] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) ?? today
        
        return events.filter { event in
            event.startDate >= today && event.startDate < tomorrow
        }
    }
    
    // 次の予定を取得（AI解析対象）
    var nextEvent: CalendarEvent? {
        let now = Date()
        return events.first { $0.startDate > now }
    }
}
