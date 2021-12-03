//
//  ResultDetailUseCase.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation

final class ResultDetailUseCase {
    private let model: ResultDetailData
    private let repository: ResultDetailRepository
    private(set) var isImageVisibilityOn: Bool

    init(model: ResultDetailData, repository: ResultDetailRepository) {
        self.model = model
        self.repository = repository
        self.isImageVisibilityOn = true
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

    func toggleImageVisibility(completion: @escaping (Bool) -> Void) {
        isImageVisibilityOn.toggle()
        completion(isImageVisibilityOn)
    }
}
