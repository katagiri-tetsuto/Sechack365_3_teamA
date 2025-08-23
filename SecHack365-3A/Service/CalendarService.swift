//
//  CalendarService.swift
//  SecHack365-3A
//
//  Created by 片岡昴晴 on 2025/08/23.
//

import Foundation
import EventKit

@MainActor
final class CalendarService: ObservableObject, Sendable {
    private let eventStore = EKEventStore()
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @Published var events: [CalendarEvent] = []
    
    init() {
        checkAuthorizationStatus()
    }
    
    // 認証状態を確認
    private func checkAuthorizationStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    // カレンダーアクセス許可を要求（iOS 17対応）
    func requestAccess() async {
        do {
            let granted = try await eventStore.requestFullAccessToEvents()
            // @MainActorで実行されているため、DispatchQueue.main.asyncは不要
            authorizationStatus = granted ? .fullAccess : .denied
        } catch {
            print("カレンダーアクセス許可エラー: \(error)")
            authorizationStatus = .denied
        }
    }
    
    // 今日から指定日数分のイベントを取得
    func fetchEvents(daysAhead: Int = 7) {
        guard authorizationStatus == .fullAccess else {
            print("カレンダーアクセスが許可されていません")
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: daysAhead, to: startDate) ?? startDate
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let ekEvents = eventStore.events(matching: predicate)
        
        events = ekEvents.map { CalendarEvent(from: $0) }
            .sorted { $0.startDate < $1.startDate }
    }
    
    // 特定の日のイベントを取得
    func fetchEventsForDate(_ date: Date) {
        guard authorizationStatus == .fullAccess else {
            print("カレンダーアクセスが許可されていません")
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        let predicate = eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
        let ekEvents = eventStore.events(matching: predicate)
        
        events = ekEvents.map { CalendarEvent(from: $0) }
            .sorted { $0.startDate < $1.startDate }
    }
}
