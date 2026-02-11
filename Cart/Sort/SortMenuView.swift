//
//  SortMenuView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import SwiftUI

// MARK: - SortMenuView

struct SortMenuView: View {
    @Binding var isShowingSortMenu: Bool
    let title: String
    let options: [SortOption]
    let closeButtonTitle: String

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            if isShowingSortMenu {
                // MARK: - Background

                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isShowingSortMenu = false }
                    }

                // MARK: - Menu Container

                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        // MARK: - Options List

                        Text(title)
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                            .padding(.vertical, 12)

                        Divider()

                        ForEach(Array(options.enumerated()), id: \.element.id) {
                            index, option in

                            Button(action: {
                                withAnimation { isShowingSortMenu = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                        option.action()
                                    }
                                }
                            }
                            ) {
                                Text(option.title)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                            }

                            if index < options.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(.menuBackground)
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)

                    // MARK: - Close Button

                    Button(action: { withAnimation { isShowingSortMenu = false }
                    }) {
                        Text(closeButtonTitle)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(.whiteAdaptive)
                            )
                    }
                    .padding(.horizontal, 8)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .animation(.easeOut(duration: 0.22), value: isShowingSortMenu)
    }
}

// MARK: - Preview

#Preview("Sort Menu Light") {
    @Previewable @State var isShowingSortMenu = true
    let options = [
        SortOption(title: "По цене", action: { print("Сортировка по цене") }),
        SortOption(title: "По названию", action: { print("Сортировка по названию") }),
        SortOption(title: "По рейтингу", action: { print("Сортировка по рейтингу") }),
    ]

    SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "Сортировка", options: options, closeButtonTitle: "Закрыть")
        .preferredColorScheme(.light)
}

#Preview("Sort Menu Dark") {
    @Previewable @State var isShowingSortMenu = true
    let options = [
        SortOption(title: "По цене", action: { print("Сортировка по цене") }),
        SortOption(title: "По названию", action: { print("Сортировка по названию") }),
        SortOption(title: "По рейтингу", action: { print("Сортировка по рейтингу") }),
    ]

    SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "Сортировка", options: options, closeButtonTitle: "Закрыть")
        .preferredColorScheme(.dark)
}
