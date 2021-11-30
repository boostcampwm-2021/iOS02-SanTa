//
//  ResultUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/11.
//

import Foundation
import OSLog

protocol ResultRepository {
    func fetch(completion: @escaping (Result<[Records], Error>) -> Void)
}

final class ResultUseCase {
    private let resultRepository: ResultRepository
    private(set) var totalRecords: TotalRecords?
    
    init(resultRepository: ResultRepository) {
        self.resultRepository = resultRepository
    }
    
    func fetch(completion: @escaping (Void?) -> Void) {
        self.resultRepository.fetch { [weak self] result in
            switch result {
            case .success(let allRecords):
                self?.totalRecords = TotalRecords()
                allRecords.forEach {
                    self?.totalRecords?.add(records: $0)
                }
                completion(Void())
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                self?.totalRecords = nil
                completion(nil)
            }
        }
    }
}

