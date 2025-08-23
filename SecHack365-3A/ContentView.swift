//
//  ContentView.swift
//  SecHack365-3A
//
//  Created by 片岡昴晴 on 2025/08/23.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // ヘッダー
                headerView
                
                // カレンダーアクセス許可セクション
                if viewModel.needsAuthorization {
                    accessPermissionView
                } else {
                    // イベントリスト
                    eventListView
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("スマートエアコン制御")
            .task {
                if viewModel.authorizationStatus == .fullAccess {
                    viewModel.loadEvents()
                }
            }
        }
    }
    
    // ヘッダービュー
    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40))
                .foregroundStyle(.blue)
            
            Text("カレンダー連携エアコン制御")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("予定に基づいて自動でエアコンを制御します")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // アクセス許可ビュー
    private var accessPermissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("カレンダーアクセスが必要です")
                .font(.headline)
            
            Text("予定情報を取得するために、カレンダーへのアクセス許可が必要です。")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            if viewModel.isLoading {
                ProgressView("アクセス許可を確認中...")
            } else {
                Button("カレンダーアクセスを許可") {
                    Task {
                        await viewModel.requestCalendarAccess()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // イベントリストビュー
    private var eventListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今後の予定")
                    .font(.headline)
                
                Spacer()
                
                Button("更新") {
                    viewModel.loadEvents()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                        .controlSize(.small)
                    Text("予定を読み込み中...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else if viewModel.events.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 30))
                        .foregroundStyle(.gray)
                    Text("今後7日間の予定がありません")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.events) { event in
                            EventRowView(event: event)
                        }
                    }
                }
            }
        }
    }
}

struct EventRowView: View {
    let event: CalendarEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                if event.isAllDay {
                    Text("終日")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .cornerRadius(8)
                }
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)
                Text(formatEventTime(event))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            if let location = event.location, !location.isEmpty {
                HStack {
                    Image(systemName: "location")
                        .foregroundStyle(.secondary)
                    Text(location)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            if let notes = event.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatEventTime(_ event: CalendarEvent) -> String {
        let formatter = DateFormatter()
        
        if event.isAllDay {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: event.startDate)
        } else {
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let startTime = formatter.string(from: event.startDate)
            
            formatter.dateStyle = .none
            let endTime = formatter.string(from: event.endDate)
            
            return "\(startTime) - \(endTime)"
        }
    }
}

#Preview {
    ContentView()
}
