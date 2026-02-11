//
//  SortMenuView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import SwiftUI

struct SortMenuView: View {
    @Binding var isShowingSortMenu: Bool
    let title: String
    let options: [SortOption]
    let closeButtonTitle: String

    var body: some View {
        GeometryReader { _ in
            if isShowingSortMenu {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isShowingSortMenu = false }
                    }
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("Title")
                            .font(.caption2)
                            .foregroundStyle(Color.gray)
                            .padding(.vertical, 12)
                        
                        Divider()
                        
                        ForEach(Array(options.enumerated()), id: \.element.id) {
                            index, option in
                            
                            Button(action: {
                                withAnimation{ isShowingSortMenu = false
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
                            .fill(Color.mint) // Change color
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    
                    Button(action: {withAnimation{ isShowingSortMenu = false }
                    }) {
                        Text(closeButtonTitle)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color(UIColor.systemBackground))
                            )
                    }
                    .padding(.horizontal, 8)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottom)
            }
        }
        .animation(.easeOut(duration: 0.22),value: isShowingSortMenu)
    }
}

#Preview ("SortMenu") {
    @Previewable @State var isShowingSortMenu = true
    let options = [
            SortOption(title: "По цене", action: { print("Сортировка по цене") }),
            SortOption(title: "По названию", action: { print("Сортировка по названию") }),
            SortOption(title: "По рейтингу", action: { print("Сортировка по рейтингу") })
        ]
    
    SortMenuView(isShowingSortMenu: $isShowingSortMenu, title: "nav", options: options, closeButtonTitle: "Cancel")
}
