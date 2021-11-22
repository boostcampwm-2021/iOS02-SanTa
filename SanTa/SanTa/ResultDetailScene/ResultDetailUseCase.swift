//
//  ResultDetailUseCase.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation

class ResultDetailUseCase {
    private let model: ResultDetailData
    private let repository: ResultDetailRepository
    
    init(model: ResultDetailData, repository: ResultDetailRepository) {
        self.model = model
        self.repository = repository
    }
    
    func transferResultDetailData(completion: (ResultDetailData) -> Void) {
        completion(self.model)
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.repository.delete(id: id, completion: completion)
    }
    
    func update(title: String, id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.repository.update(title: title, id: id, completion: completion)
    }
}
