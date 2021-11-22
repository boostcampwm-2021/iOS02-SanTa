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
    var distanceViewModel: DistanceViewModel {
        return DistanceViewModel(distanceData: self.resultDetailData?.distance)
    }
    var timeViewModel: TimeViewModel {
        return TimeViewModel(timeData: self.resultDetailData?.time)
    }
    var altitudeViewModel: AltitudeViewModel {
        return AltitudeViewModel(altitudeData: self.resultDetailData?.altitude)
    }
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
    
    func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = self.resultDetailData?.id else {
            return
        }
        self.useCase.delete(id: id, completion: completion)
    }
    
    func update(title: String, completion: @escaping (String) -> Void) {
        guard let id = self.resultDetailData?.id else {
            return
        }
        self.useCase.update(title: title, id: id) { result in
            switch result {
            case .success():
                self.resultDetailData?.change(title: title)
                completion(title)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func averageSpeed() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let totalDistance = self.resultDetailData?.distance.total ?? 0
        let totalTimeSpent = self.resultDetailData?.time.spent ?? 1
        print(totalTimeSpent)
        return formatter.string(from: NSNumber(value: totalDistance / totalTimeSpent)) ?? ""
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
        let totalDistance: String
        let steps: String
        let contents: [CellContentEntity]
        
        init(distanceData: ResultDistance?) {
            guard let distanceData = distanceData else {
                self.totalDistance = ""
                self.steps = ""
                self.contents = []
                return
            }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            guard let total = formatter.string(from: NSNumber(value: distanceData.total)),
                  let steps = formatter.string(from: NSNumber(value: distanceData.steps)) else {
                      self.contents = []
                      self.totalDistance = ""
                      self.steps = ""
                      return
                  }
            self.totalDistance = total
            self.steps = steps
            self.contents = [
                CellContentEntity(content: total, contentTitle: "전체"),
                CellContentEntity(content: steps, contentTitle: "걸음수")
            ]
        }
    }
    
    struct TimeViewModel: ResultDetailCellRepresentable {
        var title: String = "시간"
        let totalTimeSpent: String
        var contents: [CellContentEntity]
        
        init(timeData: ResultTime?) {
            guard let timeData = timeData else {
                self.totalTimeSpent = ""
                self.contents = []
                return
            }
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .pad
            guard let spent = formatter.string(from: timeData.spent),
                  let active = formatter.string(from: timeData.active),
                  let inactive = formatter.string(from: timeData.inactive) else {
                      self.contents = []
                      self.totalTimeSpent = ""
                      return
                  }
            self.totalTimeSpent = spent
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
        let highest: String
        let lowest: String
        var contents: [CellContentEntity]
        
        init(altitudeData: ResultAltitude?) {
            guard let altitudeData = altitudeData else {
                self.highest = ""
                self.lowest = ""
                self.contents = []
                return
            }
            self.contents = [
                CellContentEntity(content: String(altitudeData.total), contentTitle: "누적"),
                CellContentEntity(content: String(altitudeData.highest), contentTitle: "최고"),
                CellContentEntity(content: String(altitudeData.lowest), contentTitle: "최저"),
                CellContentEntity(content: String(altitudeData.starting), contentTitle: "시작"),
                CellContentEntity(content: String(altitudeData.ending), contentTitle: "종료"),
            ]
            self.highest = String(altitudeData.highest)
            self.lowest = String(altitudeData.lowest)
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
