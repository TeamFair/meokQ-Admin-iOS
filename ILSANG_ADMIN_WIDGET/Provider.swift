//
//  Provider.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 9/2/24.
//

import WidgetKit

// MARK: - 타임라인엔트리
struct IlsangTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var prdServerStatus: Status
    var devServerStatus: Status
    var count: Int
}


// MARK: -  프로바이더
struct Provider: AppIntentTimelineProvider {
    
    /// 플레이스홀더
    func placeholder(in context: Context) -> IlsangTimelineEntry {
        IlsangTimelineEntry(date: Date(), configuration: ConfigurationAppIntent(), prdServerStatus: .able, devServerStatus: .able, count: 0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> IlsangTimelineEntry {
        IlsangTimelineEntry(date: Date(), configuration: configuration, prdServerStatus: .able, devServerStatus: .able, count: 0)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<IlsangTimelineEntry> {
        var entries: [IlsangTimelineEntry] = []
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 0, to: currentDate)!

        // TODO: 로딩 상태로 타임라인 엔트리 추가 동작되도록 수정 필요
        let loadingEntry = IlsangTimelineEntry(date: entryDate, configuration: configuration, prdServerStatus: .loading, devServerStatus: .loading, count: 0)
        entries.append(loadingEntry)
                
        // API 호출 및 데이터 처리
        let apiData = await fetchDataFromServer()
        
        let entry = IlsangTimelineEntry(
            date: entryDate.addingTimeInterval(15),
            configuration: configuration,
            prdServerStatus: apiData.prd ? Status.able : Status.disable,
            devServerStatus: apiData.dev ? Status.able : Status.disable,
            count: apiData.cnt
        )
        entries[entries.count-1] = entry
        
        //  6시간마다 타임라인 갱신하도록 설정
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate)!
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}


// MARK: - 네트워크 관련
extension Provider {
    private struct NetworkResult {
        let prd: Bool
        let dev: Bool
        let cnt: Int
    }
    
    private func fetchDataFromServer() async -> NetworkResult {
        return await NetworkResult(
            prd: checkPrdServerStatus(),
            dev: checkDevServerStatus(),
            cnt: getReportedChallengeCount()
        )
    }
    
    private func checkPrdServerStatus() async -> Bool {
        let url = "http://52.79.126.243:8881/api/admin/quest?page=0&creatorRole=ADMIN&size=10"
        let result: Result<GetQuestResponse, Error> = await Network.request(url: url)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    private func checkDevServerStatus() async -> Bool {
        let url = "http://52.79.126.243:8880/api/admin/quest?page=0&creatorRole=ADMIN&size=10"
        let result: Result<GetQuestResponse, Error> = await Network.request(url: url)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    private func getReportedChallengeCount() async -> Int {
        let url = "http://52.79.126.243:8881/api/admin/report?page=0&size=10"
        let result: Result<GetChallengeResponse, Error> = await Network.request(url: url)
        switch result {
        case .success(let res):
            return res.total
        case .failure:
            return 0
        }
    }
}
