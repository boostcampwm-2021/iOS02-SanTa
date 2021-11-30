//
//  ResultDetailViewModel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import CoreLocation
import Combine

final class ResultDetailViewModel {
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
    var paceViewModel: PaceViewModel {
        return PaceViewModel(paceData: self.resultDetailData?.pace)
    }
    var inclineViewMedel: InclineViewModel {
        return InclineViewModel(inclineData: self.resultDetailData?.incline)
    }
    @Published var imageVisibilityIconName: String?
    let imageVisibilityStatus = PassthroughSubject<Bool, Never>()

    init(useCase: ResultDetailUseCase) {
        self.useCase = useCase
        self.recordDidFetch = {}
    }

    func setUp() {
        self.useCase.transferResultDetailData { [weak self] dataModel in
            self?.resultDetailData = dataModel
            self?.recordDidFetch()
        }
        self.imageVisibilityIconName = useCase.isImageVisibilityOn ? "eye" : "eye.slash"
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
            case .success:
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
        guard let distance = self.resultDetailData?.distance.total,
              let totalTime = self.resultDetailData?.time.spent, totalTime > 0,
              let speed = formatter.string(from: NSNumber(value: distance * 3600 / totalTime)) else {
                  return "-"
              }
        return speed
    }

    lazy var recordDate: String = {
        guard let endTime = self.resultDetailData?.timeStamp.endTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy. MM. dd. (E)"
        return dateFormatter.string(from: endTime)
    }()

    lazy var startTime: String = {
        guard let startTime = self.resultDetailData?.timeStamp.startTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "a h시 m분"
        return dateFormatter.string(from: startTime)
    }()

    lazy var endTime: String = {
        guard let endTime = self.resultDetailData?.timeStamp.endTime else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "a h시 m분"
        return dateFormatter.string(from: endTime)
    }()

    func imageVisibilityButtonTouched() {
        self.useCase.toggleImageVisibility { [weak self] bool in
            bool ? (self?.imageVisibilityIconName = "eye") : (self?.imageVisibilityIconName = "eye.slash")
            self?.imageVisibilityStatus.send(bool)
        }
    }
}

struct CellContentEntity {
    let content: String
    let contentTitle: String
}

protocol ResultDetailCellRepresentable: Hashable {
    var title: String { get }
    var contents: [CellContentEntity] { get }
}

class DetailInformationModel: Hashable {
    var id: UUID = UUID()
    var title: String = ""
    var contents: [CellContentEntity] = []

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DetailInformationModel, rhs: DetailInformationModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension ResultDetailViewModel {
    final class DistanceViewModel: DetailInformationModel {
        var totalDistance: String = "-"
        var steps: String = "0"

        init(distanceData: ResultDistance?) {
            super.init()
            guard let distanceData = distanceData else {
                return
            }
            self.title = "거리"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            if let steps = formatter.string(from: NSNumber(value: distanceData.steps)) {
                self.steps = steps
            }

            if let distance = distanceData.total,
               let total = formatter.string(from: NSNumber(value: distance)) {
                self.totalDistance = total
            }
            self.contents = [
                CellContentEntity(content: self.totalDistance, contentTitle: "전체"),
                CellContentEntity(content: self.steps, contentTitle: "걸음수")
            ]
        }
    }

    final class TimeViewModel: DetailInformationModel {
        var totalTimeSpent: String = ""

        init(timeData: ResultTime?) {
            super.init()
            guard let timeData = timeData else {
                return
            }
            self.title = "시간"
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .pad
            guard let spent = formatter.string(from: timeData.spent),
                  let active = formatter.string(from: timeData.active),
                  let inactive = formatter.string(from: timeData.inactive) else {
                      return
                  }
            self.totalTimeSpent = spent
            self.contents = [
                CellContentEntity(content: spent, contentTitle: "소요"),
                CellContentEntity(content: active, contentTitle: "운동"),
                CellContentEntity(content: inactive, contentTitle: "휴식")
            ]
        }
    }

    final class PaceViewModel: DetailInformationModel {
        init(paceData: ResultPace?) {
            super.init()
            guard let pace = paceData else {
                return
            }
            self.title = "페이스(1km당 소요시간)"
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .pad
            guard let averagePace = formatter.string(from: pace.timePerKilometer),
                  let fastest = formatter.string(from: pace.fastestPace),
                  let slowest = formatter.string(from: pace.slowestPace) else {
                      return
                  }
            self.contents = [
                CellContentEntity(content: averagePace, contentTitle: "평균"),
                CellContentEntity(content: fastest, contentTitle: "최고"),
                CellContentEntity(content: slowest, contentTitle: "최저")
            ]
        }
    }

    final class AltitudeViewModel: DetailInformationModel {
        var highest: String = "-"
        var lowest: String = "-"

        init(altitudeData: ResultAltitude?) {
            super.init()
            guard let altitudeData = altitudeData else {
                return
            }
            self.title = "고도"
            var totalString = "-"
            var highestString = "-"
            var lowestString = "-"
            var startingString = "-"
            var endingString = "-"

            if let total = altitudeData.total {
                totalString = String(total)
            }

            if let highest = altitudeData.highest {
                highestString = String(highest)
                self.highest = highestString
            }

            if let lowest = altitudeData.lowest {
                lowestString = String(lowest)
                self.lowest = lowestString
            }

            if let start = altitudeData.starting {
                startingString = String(start)
            }

            if let end = altitudeData.ending {
                endingString = String(end)
            }

            self.contents = [
                CellContentEntity(content: totalString, contentTitle: "누적"),
                CellContentEntity(content: highestString, contentTitle: "최고"),
                CellContentEntity(content: lowestString, contentTitle: "최저"),
                CellContentEntity(content: startingString, contentTitle: "시작"),
                CellContentEntity(content: endingString, contentTitle: "종료")
            ]
        }
    }

    final class InclineViewModel: DetailInformationModel {
        init(inclineData: ResultIncline?) {
            super.init()
            guard let inclineData = inclineData else {
                return
            }
            self.title = "경사도"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            guard let uphill = formatter.string(from: NSNumber(value: inclineData.uphillKilometer)),
                  let downhill = formatter.string(from: NSNumber(value: inclineData.downhillKilometer)),
                  let plain = formatter.string(from: NSNumber(value: inclineData.plainKilometer)) else {
                      return
                  }
            self.contents = [
                CellContentEntity(content: String(inclineData.average)+"°", contentTitle: "평균"),
                CellContentEntity(content: String(inclineData.highest)+"°", contentTitle: "최고"),
                CellContentEntity(content: uphill, contentTitle: "오르막(km)"),
                CellContentEntity(content: downhill, contentTitle: "내리막(km)"),
                CellContentEntity(content: plain, contentTitle: "평지(km)")
            ]
        }
    }
}
