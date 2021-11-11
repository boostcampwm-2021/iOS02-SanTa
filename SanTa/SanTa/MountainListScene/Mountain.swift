//
//  Mountain.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/11.
//

import Foundation

struct Mountain: Hashable {
    var id = UUID()
    let name: String
    let height: String
    let location: String
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: Mountain, rhs: Mountain) -> Bool {
      lhs.id == rhs.id
    }
}
