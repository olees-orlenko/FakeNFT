//
//  CollectionFilter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Олеся Орленко on 10.02.2026.
//

import SwiftUI

// MARK: - Collection Filter

struct CollectionFilter: View {
    
    // MARK: - Properties
    
    @Binding var isPresented: Bool
    let onSortByName: () -> Void
    let onSortByCount: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            if isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isPresented = false }
                    }
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text(NSLocalizedString("Sorting", comment: ""))
                            .font(.caption2)
                            .foregroundColor(Color(.sortingText))
                            .padding(.top, 12)
                            .padding(.bottom, 12)
                        Divider()
                        Button(action: {
                            withAnimation { isPresented = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                onSortByName()
                            }
                        }) {
                            Text(NSLocalizedString("Filter.textName", comment: ""))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                        }
                        Divider()
                        Button(action: {
                            withAnimation { isPresented = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                onSortByCount()
                            }
                        }) {
                            Text(NSLocalizedString("Filter.textNFT", comment: ""))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(Color(UIColor.sortingBackground))
                    )
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    Button(action: {
                        withAnimation { isPresented = false }
                    }) {
                        Text(NSLocalizedString("Close.Button", comment: ""))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(Color(UIColor.systemBackground))
                            )
                    }
                    .padding(.horizontal, 8)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .animation(.easeOut(duration: 0.22), value: isPresented)
    }
}

// MARK: - Preview

#Preview("CollectionFilter light") {
    Group {
        CollectionFilter(isPresented: .constant(true),
                         onSortByName: { },
                         onSortByCount: { })
    }
    .preferredColorScheme(.light)
}

#Preview("CollectionFilter dark") {
    Group {
        CollectionFilter(isPresented: .constant(true),
                         onSortByName: { },
                         onSortByCount: { })
    }
    .preferredColorScheme(.dark)
}
