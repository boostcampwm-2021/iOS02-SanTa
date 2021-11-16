//
//  ResultDetailViewModel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation

enum ResultDataType: String, CaseIterable {
    case start = "시작"
    case end = "종료"
    case distance = "거리"
    case time = "시간"
    case pace = "페이스(1km당 소요시간)"
    case altitude = "고도"
    case incline = "경사도"
}

struct CellContentEntity {
    let content: String
    let subContent: String?
    let contentTitle: String?
}

protocol CellRepresentableData {
    var type: ResultDataType { get }
    var contents: [CellContentEntity] { get }
}
