import SwiftUI

// MARK: - Statistics Sort Filter

struct StatisticsSortSheet: View {

    // MARK: - Properties

    @Binding var isPresented: Bool
    let selected: StatisticsSortType
    let onSelect: (StatisticsSortType) -> Void

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
                                onSelect(.byName)
                            }
                        }) {
                            Text(StatisticsSortType.byName.rawValue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                        }

                        Divider()

                        Button(action: {
                            withAnimation { isPresented = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                onSelect(.byRating)
                            }
                        }) {
                            Text(StatisticsSortType.byRating.rawValue)
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

#Preview("StatisticsSortSheet light") {
    StatisticsSortSheet(
        isPresented: .constant(true),
        selected: .byRating,
        onSelect: { _ in }
    )
    .preferredColorScheme(.light)
}

#Preview("StatisticsSortSheet dark") {
    StatisticsSortSheet(
        isPresented: .constant(true),
        selected: .byRating,
        onSelect: { _ in }
    )
    .preferredColorScheme(.dark)
}

