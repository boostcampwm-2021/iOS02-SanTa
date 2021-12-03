//
//  ResultRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/11.
//

import Foundation

final class DefaultResultRepository: ResultRepository {

    private let recordStorage: CoreDataRecordStorage

    init(recordStorage: CoreDataRecordStorage) {
        self.recordStorage = recordStorage
    }

    func fetch(completion: @escaping (Result<[Records], Error>) -> Void) {
        self.recordStorage.fetch { result in
            switch result {
            case .success(let objects):
                var allRecords: [Records] = []
                objects.reversed().forEach {
                    guard let records = self.makeRecords(recordsEntityMO: $0) else { return }
                    allRecords.append(records)
                }
                completion(.success(allRecords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func makeRecords(recordsEntityMO: RecordsEntityMO) -> Records? {
        guard let title = recordsEntityMO.title,
              let archiveAssetIdentifiers = recordsEntityMO.assetIdentifiers,
              let id = recordsEntityMO.id,
              let assetIdentifiers = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: archiveAssetIdentifiers) as? [String] else { return nil }
        let secondPerHighestSpeed = Int(recordsEntityMO.secondPerHighestSpeed)
        let secondPerMinimumSpeed = Int(recordsEntityMO.secondPerMinimumSpeed)

        var records: [Record] = []
        recordsEntityMO.records?.forEach {
            guard let recordEntityMO = $0 as? RecordEntityMO else { return }
            guard let record = self.makeRecord(recordEntityMO: recordEntityMO) else { return }
            records.append(record)
        }
        return Records(title: title, records: records, assetIdentifiers: assetIdentifiers, secondPerHighestSpeed: secondPerHighestSpeed, secondPerMinimumSpeed: secondPerMinimumSpeed, id: id)

    }

    private func makeRecord(recordEntityMO: RecordEntityMO) -> Record? {
        guard let startTime = recordEntityMO.startTime else { return nil }
        guard let endTime = recordEntityMO.endTime else { return nil }
        let step = Int(recordEntityMO.step)
        let distance = recordEntityMO.distance

        var locations: [Location] = []
        recordEntityMO.locations?.forEach {
            guard let locationEntityMO = $0 as? LocationEntityMO else { return }
            let location = Location(latitude: locationEntityMO.latitude,
                                    longitude: locationEntityMO.longitude,
                                    altitude: locationEntityMO.altitude)
            locations.append(location)
        }
        return Record(startTime: startTime,
                      endTime: endTime,
                      step: step,
                      distance: distance,
                      locations: locations)
    }

}
