//
//  MountainListViewModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/11.
//

import Combine

final class MountainListViewModel {
    @Published private(set) var mountains: [MountainEntity]?
    @Published var mountainName: String?

    private let useCase: MountainListUseCase
    private var cancellables = Set<AnyCancellable>()

    init(useCase: MountainListUseCase) {
        self.useCase = useCase
    }

    func viewDidLoad() {
        self.useCase.prepareMountainList { [weak self] mountains in
            self?.mountains = mountains
        }
    }

    func findMountains() {
        guard let name = mountainName else { return }
        self.useCase.findMountains(name: name) { [weak self] mountains in
            self?.mountains = mountains
        }
    }
}
