//
//  CoreDataRecordsStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation
import CoreData

protocol RecordsStorage {
    func save(record: Record,
              completion: @escaping (Result<Records, Error>) -> Void)
}

final class CoreDataRecordStorage: RecordsStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage) {
       self.coreDataStorage = coreDataStorage
    }
    
    func save(record: Record, completion: @escaping (Result<Records, Error>) -> Void) {
        self.coreDataStorage.performBackgroundTask { context in
            let recordObject = NSEntityDescription.insertNewObject(forEntityName: "RecordEntity",
                                                                   into: context)
//            recordObject.setValue(record.time, forKey: "time")
            recordObject.setValue(record.distance, forKey: "distance")
            recordObject.setValue(record.step, forKey: "step")
            
            record.locations.forEach {
                let locationObject = NSEntityDescription.insertNewObject(forEntityName: "LocationEntity",
                                                                         into: context) as? LocationEntityMO
                locationObject?.altitude = $0.altitude
                locationObject?.latitude = $0.latitude
                locationObject?.longitude = $0.longitude
                
                guard let locationObject = locationObject else { return }
                (recordObject as? RecordEntityMO)?.addToLocations(locationObject)
            }
            
            do {
                try context.save()
//                completion(.success(record))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
}
