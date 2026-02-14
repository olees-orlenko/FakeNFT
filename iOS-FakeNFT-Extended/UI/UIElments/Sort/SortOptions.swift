//
//  SortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import Foundation

struct SortOption: Identifiable {
    let id = UUID()
    let title: String
    let action: () -> Void
}
