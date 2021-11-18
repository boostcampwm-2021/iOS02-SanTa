//
//  ResultDetailViewModel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation
import CoreLocation

class ResultDetailViewModel {
    private let useCase: ResultDetailUseCase
    var resultDetailData: ResultDetailData?
    var recordDidFetch: () -> Void
    
    init(useCase: ResultDetailUseCase) {
        self.useCase = useCase
        self.recordDidFetch = {}
    }
    
    func setUp() {
        self.useCase.transferResultDetailData { [weak self] dataModel in
            self?.resultDetailData = dataModel
            self?.recordDidFetch()
        }
    }
    
    var recordDate: String {
        guard let endTime = self.resultDetailData?.timeStamp.endTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy. MM. dd. (E)"
        return dateFormatter.string(from: endTime)
    }
    
    var startDate: String {
        guard let startTime = self.resultDetailData?.timeStamp.startTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "a h시 m분"
        return dateFormatter.string(from: startTime)
    }
    
    var endDate: String {
        guard let endTime = self.resultDetailData?.timeStamp.endTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "a h시 m분"
        return dateFormatter.string(from: endTime)
    }
}

struct CellContentEntity {
    let content: String
    let contentTitle: String
}

protocol ResultDetailCellRepresentable {
    var title: String { get }
    var contents: [CellContentEntity] { get }
}

extension ResultDetailViewModel {
    
    
    struct DistanceViewModel: ResultDetailCellRepresentable {
        let title: String = "거리"
        let contents: [CellContentEntity]
        
        init(distanceData: ResultDistance) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            guard let total = formatter.string(from: NSNumber(value: distanceData.total)),
                  let steps = formatter.string(from: NSNumber(value: distanceData.steps)) else {
                      self.contents = []
                      return
                  }
            self.contents = [
                CellContentEntity(content: total, contentTitle: "전체"),
                CellContentEntity(content: steps, contentTitle: "걸음수")
            ]
        }
    }
    
    struct TimeViewModel: ResultDetailCellRepresentable {
        var title: String = "시간"
        var contents: [CellContentEntity]
        
        init(timeData: ResultTime) {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            guard let spent = formatter.string(from: timeData.spent),
                  let active = formatter.string(from: timeData.active),
                  let inactive = formatter.string(from: timeData.inactive) else {
                      self.contents = []
                      return
                  }
            self.contents = [
                CellContentEntity(content: spent, contentTitle: "소요"),
                CellContentEntity(content: active, contentTitle: "운동"),
                CellContentEntity(content: inactive, contentTitle: "휴식"),
            ]
        }
    }
    
    struct PaceViewModel: ResultDetailCellRepresentable {
        var title: String = "페이스(1km당 소요시간)"
        var contents: [CellContentEntity]
        
        
    }
    
    struct AltitudeViewModel: ResultDetailCellRepresentable {
        var title: String = "고도"
        var contents: [CellContentEntity]
        
        init(altitudeData: ResultAltitude) {
            self.contents = [
                CellContentEntity(content: String(altitudeData.total), contentTitle: "누적"),
                CellContentEntity(content: String(altitudeData.highest), contentTitle: "최고"),
                CellContentEntity(content: String(altitudeData.lowest), contentTitle: "최저"),
                CellContentEntity(content: String(altitudeData.starting), contentTitle: "시작"),
                CellContentEntity(content: String(altitudeData.ending), contentTitle: "종료"),
            ]
        }
    }
    
    struct InclineViewModel: ResultDetailCellRepresentable {
        var title: String = "경사도"
        var contents: [CellContentEntity]
        
        init(inclineData: ResultIncline) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            guard let uphill = formatter.string(from: NSNumber(value: inclineData.uphillKilometer)),
                  let downhill = formatter.string(from: NSNumber(value: inclineData.downhillKilometer)),
                  let plain = formatter.string(from: NSNumber(value: inclineData.plainKilometer)) else {
                      self.contents = []
                      return
                  }
            self.contents = [
                CellContentEntity(content: String(inclineData.average), contentTitle: "평균"),
                CellContentEntity(content: String(inclineData.highest), contentTitle: "최고"),
                CellContentEntity(content: uphill, contentTitle: "오르막(km)"),
                CellContentEntity(content: downhill, contentTitle: "내리막(km)"),
                CellContentEntity(content: plain, contentTitle: "평지(km)"),
            ]
        }
    }
}
