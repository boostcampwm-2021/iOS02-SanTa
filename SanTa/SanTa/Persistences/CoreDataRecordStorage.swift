//
//  CoreDataRecordsStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation
import CoreData

protocol RecordsStorage {
    func save(records: Records,
              completion: @escaping (Result<Records, CoreDataError>) -> Void)
    func fetch(completion: @escaping (Result<[RecordsEntityMO], Error>) -> Void)
}

final class CoreDataRecordStorage: RecordsStorage {
   
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage) {
       self.coreDataStorage = coreDataStorage
    }
    
    func save(records: Records, completion: @escaping (Result<Records, CoreDataError>) -> Void) {
        self.coreDataStorage.performBackgroundTask { context in
            let recordsObject = NSEntityDescription.insertNewObject(forEntityName: "RecordsEntity",
                                                                    into: context)
            
            recordsObject.setValue(records.title, forKey: "title")
            
            records.records.forEach {
                let recordObject = NSEntityDescription.insertNewObject(forEntityName: "RecordEntity",
                                                                       into: context) as? RecordEntityMO
                
                recordObject?.startTime = $0.startTime
                recordObject?.endTime = $0.endTime
                recordObject?.distance = $0.distance
                recordObject?.step = Int16($0.step)
                
                guard let recordObject = recordObject else { return }
                (recordsObject as? RecordsEntityMO)?.addToRecords(recordObject)
                
                $0.locations.forEach {
                    let locationObject = NSEntityDescription.insertNewObject(forEntityName: "LocationEntity",
                                                                             into: context) as? LocationEntityMO
                    locationObject?.altitude = $0.altitude
                    locationObject?.latitude = $0.latitude
                    locationObject?.longitude = $0.longitude
                    
                    guard let locationObject = locationObject else { return }
                    recordObject.addToLocations(locationObject)
                }
            }
            
            do {
                try context.save()
                completion(.success(records))
            } catch {
                completion(.failure(CoreDataError.coreDataError))
            }
        }
    }
    
    func fetch(completion: @escaping (Result<[RecordsEntityMO], Error>) -> Void) {
        self.coreDataStorage.performBackgroundTask { context in
            do {
                let request = NSFetchRequest<RecordsEntityMO>(entityName: "RecordsEntity")
                let result = try context.fetch(request)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
