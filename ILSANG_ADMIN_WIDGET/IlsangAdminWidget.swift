//
//  IlsangAdminWidget.swift
//  IlsangAdminWidget
//
//  Created by Lee Jinhee on 9/1/24.
//

import WidgetKit
import SwiftUI


// MARK: - 타임라인엔트리 & 프로바이더

struct IlsangTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var prdServerStatus: Status
    var devServerStatus: Status
    var count: Int
}

struct Provider: AppIntentTimelineProvider {
    
    /// 플레이스홀더
    func placeholder(in context: Context) -> IlsangTimelineEntry {
        IlsangTimelineEntry(date: Date(), configuration: ConfigurationAppIntent(), prdServerStatus: .able, devServerStatus: .able, count: 0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> IlsangTimelineEntry {
        // TODO: API 연결 및 데이터 확인
        IlsangTimelineEntry(date: Date(), configuration: configuration, prdServerStatus: .able, devServerStatus: .able, count: 3)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<IlsangTimelineEntry> {
        var entries: [IlsangTimelineEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            // TODO: API 연결
            let entry = IlsangTimelineEntry(date: entryDate, configuration: configuration, prdServerStatus: .able, devServerStatus: .able, count: 0)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(3600)))
    }
}


// MARK: - 위젯

struct IlsangAdminWidget: Widget {
    let kind: String = "Ilsang_Admin_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(entry.configuration.colorMode.bgColor, for: .widget)
        }
        .contentMarginsDisabled()
    }
}


struct WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("신고된 도전 내역")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(.white)
                    .opacity(0.9)
                Text("\(entry.count)")
                    .font(.title2).bold()
                    .foregroundStyle(.secondaryGreen)
            }
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text(entry.prdServerStatus.emoji)
                        .font(.system(size: 28))
                        .frame(width: 48, height: 48)
                        .background {
                            Circle()
                                .foregroundStyle(entry.prdServerStatus.bgColor)
                        }
                    Text("PRD")
                        .font(.caption).bold()
                        .foregroundStyle(.gray)
                }
                
                VStack(spacing: 6) {
                    Text(entry.devServerStatus.emoji)
                        .font(.system(size: 28))
                        .frame(width: 48, height: 48)
                        .background {
                            Circle()
                                .foregroundStyle(entry.devServerStatus.bgColor)
                        }
                    Text("DEV")
                        .font(.caption).bold()
                        .foregroundStyle(.gray)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.white)
                    .shadow(color: .black.opacity(0.14), radius: 5, x: 0, y: -6)
            )
        }
        .ignoresSafeArea()
    }
}


// MARK: - 프리뷰

extension ConfigurationAppIntent {
    fileprivate static var blackMode: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.colorMode = .blackType
        return intent
    }
    
    fileprivate static var purpleMode: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.colorMode = .purpleType
        return intent
    }
}

#Preview(as: .systemSmall) {
    IlsangAdminWidget()
} timeline: {
    IlsangTimelineEntry(date: .now, configuration: .blackMode, prdServerStatus: .able, devServerStatus: .able, count: 0)
    IlsangTimelineEntry(date: .now, configuration: .purpleMode, prdServerStatus: .able, devServerStatus: .able, count: 0)
}
