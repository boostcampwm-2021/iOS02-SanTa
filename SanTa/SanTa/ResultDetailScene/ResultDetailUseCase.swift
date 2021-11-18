//
//  ResultDetailUseCase.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation

class ResultDetailUseCase {
    private let model: ResultDetailData
    
    init(model: ResultDetailData) {
        self.model = model
    }
    
    func transferResultDetailData(completion: (ResultDetailData) -> Void) {
        completion(self.model)
    }
}
