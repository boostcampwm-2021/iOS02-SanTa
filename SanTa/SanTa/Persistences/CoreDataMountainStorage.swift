//
//  CoreDataMountainStorage.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/22.
//

import Foundation
import CoreData

protocol MountainStorage {
    func save(mountainEntity: MountainEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func fetch(completion: @escaping (Result<[MountainEntityMO], Error>) -> Void)
}

final class CoreDataMountainStorage: MountainStorage {
    enum coreDataMountainStorageError: Error {
        case saveError
        case fetchError
    }
    
    private let coreDataStroage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStroage = coreDataStorage
    }
    
    func save(mountainEntity: MountainEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        self.coreDataStroage.performBackgroundTask { context in
            let object = NSEntityDescription.insertNewObject(forEntityName: "MountainEntity", into: context)
            object.setValue(mountainEntity.id, forKey: "id")
            object.setValue(mountainEntity.latitude, forKey: "latitude")
            object.setValue(mountainEntity.longitude, forKey: "longitude")
            object.setValue(mountainEntity.mountain.mountainName, forKey: "name")
            object.setValue(mountainEntity.mountain.mountainRegion, forKey: "region")
            object.setValue(mountainEntity.mountain.mountainHeight, forKey: "altitude")
            object.setValue(mountainEntity.mountain.mountainShortDescription, forKey: "descript")
            
            do {
                try context.save()
                completion(.success(Void()))
            } catch {
                completion(.failure(coreDataMountainStorageError.saveError))
            }
        }
    }
    
    func fetch(completion: @escaping (Result<[MountainEntityMO], Error>) -> Void) {
        self.coreDataStroage.performBackgroundTask { context in
            do {
                let request = NSFetchRequest<MountainEntityMO>(entityName: "MountainEntity")
                let result = try context.fetch(request)
                completion(.success(result))
            } catch {
                completion(.failure(coreDataMountainStorageError.fetchError))
            }
        }
    }
}
