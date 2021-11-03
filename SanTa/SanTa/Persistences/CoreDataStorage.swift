//
//  CoreDataStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//  참고: https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Data/PersistentStorages/CoreDataStorage/CoreDataStorage.swift

import CoreData

final class CoreDataStorage {

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SanTa")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
}
