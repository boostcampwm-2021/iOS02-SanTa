//
//  ResultViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/15.
//

import Foundation

class ResultViewModel {
    private let useCase: ResultUseCase
    var cellShouldUpdate: () -> Void
    var totalDistance: String {
        guard let totalRecords = useCase.totalRecords else { return "" }
        return self.doubleFormatter(totalRecords.totalDistances) + " km"
    }
    var totalSections: Int {
        guard let totalRecords = useCase.totalRecords else { return 0 }
        return totalRecords.sectionCount
    }
    
    init(useCase: ResultUseCase) {
        self.useCase = useCase
        self.cellShouldUpdate = {}
    }

    func viewWillAppear(completion: @escaping () -> Void) {
        self.useCase.fetch { [weak self] void in
            guard void != nil else { return }
            self?.cellShouldUpdate()
            completion()
        }
    }
    
    func itemsInSection(section: Int) -> Int {
        useCase.totalRecords?[section]?.count ?? 0
    }
    
    func totalInfo() -> (distance: String, count: String, time: String, steps: String) {
        guard let totalRecords = useCase.totalRecords else {
            return ("", "", "", "")
        }
        let distanceString = self.doubleFormatter(totalRecords.totalDistances)
        let countString = self.intFormatter(totalRecords.totalCount)
        let timeString = self.timeFormatter(totalRecords.totalTimes)
        let stepsString = self.stepsFormatter(totalRecords.totalSteps)
        return (distanceString, countString, timeString, stepsString)
    }
    
    func sectionInfo(section: Int) -> (date: String,
                                       accessibiltyDate: String,
                                       count: String,
                                       distance: String,
                                       time: String) {
        guard let totalRecords = useCase.totalRecords,
              let dateSeperateRecords = totalRecords[section]
        else {
            return ("", "", "", "", "")
        }
        let dateString = self.headerDateFormatter(
            year: dateSeperateRecords.year,
            month: dateSeperateRecords.month
        )
        let accessibiltyDateString = self.headerAccessibiltyDateFormatter(
            year: dateSeperateRecords.year,
            month: dateSeperateRecords.month
        )
        let countString = "\(dateSeperateRecords.count)회"
        let distanceString = self.doubleFormatter(dateSeperateRecords.distances) + "km"
        let timeString = self.timeFormatter(dateSeperateRecords.times)
        return (dateString, accessibiltyDateString, countString, distanceString, timeString)
    }
    
    func cellInfo(indexPath: IndexPath)
    -> (date: String, distance: String, time: String, altitudeDifference: String, steps: String, title: String) {
        guard let totalRecords = useCase.totalRecords,
              let records = totalRecords[indexPath.section]?[indexPath.item]
        else {
            return ("", "", "", "", "", "")
        }
        let dateString = self.cellDateFormatter(records.date)
        let distanceString = self.doubleFormatter(records.distances)
        let timeString = self.timeFormatter(records.times)
        let altitudeDifferenceString = self.cellAltitudeDifferenceFormatter(records.maxAltitudeDifference)
        let stepsString = self.stepsFormatter(records.steps)
        let title = records.title
        return (dateString, distanceString, timeString, altitudeDifferenceString, stepsString, title)
    }
    
    func selectedRecords(indexPath: IndexPath) -> Records? {
        return useCase.totalRecords?[indexPath.section]?[indexPath.item]
    }
}

extension ResultViewModel {
    private func headerDateFormatter(year: Int, month: Int) -> String {
        return "\(year). \(month)."
    }
    
    private func headerAccessibiltyDateFormatter(year: Int, month: Int) -> String {
        return "\(year)년 \(month)월"
    }
    
    private func cellDateFormatter(_ date: Date?) -> String {
        guard let date = date,
              let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        else { return "알 수 없는 날짜" }
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        if calender.compare(date, to: .now, toGranularity: .day) == .orderedSame {
            dateFormatter.dateFormat = "오늘(E) a h시 m분"
        } else if calender.compare(date, to: yesterday, toGranularity: .day) == .orderedSame {
            dateFormatter.dateFormat = "어제(E) a h시 m분"
        } else {
            dateFormatter.dateFormat = "M. d. (E) a h시 m분"
        }
        return dateFormatter.string(from:date)
    }
    
    private func timeFormatter(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: time) ?? "00:00"
    }
    
    private func cellAltitudeDifferenceFormatter(_ number: Double) -> String {
        guard number < 10000 else { return "9,999+" }
        guard number > 1 else { return "-" }
        return self.intFormatter(Int(number))
    }
    
    private func stepsFormatter(_ number: Int) -> String {
        if number < 10000 {
            return self.intFormatter(number)
        } else {
            let number = Double(number)/10000.0
            return self.doubleFormatter(number) + "만"
        }
    }
    
    private func intFormatter(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "Error"
    }
    
    private func doubleFormatter(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "Error"
    }
}
