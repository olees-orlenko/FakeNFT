import SwiftUI

struct StatisticsSortSheet: View {
    @Binding var isPresented: Bool
    let selected: StatisticsSortType
    let onSelect: (StatisticsSortType) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Сортировка")
                .font(.system(size: 17, weight: .bold))
                .padding(.top, 12)

            VStack(spacing: 0) {
                sheetRow(title: StatisticsSortType.byName.rawValue, isSelected: selected == .byName) {
                    onSelect(.byName)
                    isPresented = false
                }

                Divider()

                sheetRow(title: StatisticsSortType.byRating.rawValue, isSelected: selected == .byRating) {
                    onSelect(.byRating)
                    isPresented = false
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Button("Закрыть") {
                isPresented = false
            }
            .font(.system(size: 17, weight: .regular))
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 16)
        .presentationDetents([.height(260)])
        .presentationDragIndicator(.visible)
    }

    private func sheetRow(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
