//
//  StatisticsSortSheet.swift
//  iOS-FakeNFT-Extended
//
//  Created by Филипп Герасимов on 19/02/26.
//

import SwiftUI

struct StatisticsSortSheet: View {
    @Binding var isPresented: Bool
    let selected: StatisticsSortType
    let onSelect: (StatisticsSortType) -> Void

    var body: some View {
        EmptyView()
            .confirmationDialog("Сортировка", isPresented: $isPresented, titleVisibility: .visible) {
                ForEach(StatisticsSortType.allCases, id: \ .self) { type in
                    Button(type.rawValue) {
                        onSelect(type)
                    }
                }
                Button("Закрыть", role: .cancel) {}
            }
    }
}
