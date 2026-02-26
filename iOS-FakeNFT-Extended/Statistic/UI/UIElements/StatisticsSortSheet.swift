import SwiftUI

struct StatisticsSortSheet: View {
    @Binding var isPresented: Bool
    let selected: StatisticsSortType
    let onSelect: (StatisticsSortType) -> Void

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                Text("Сортировка")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)

                Divider()

                sheetRow(title: StatisticsSortType.byName.rawValue) {
                    onSelect(.byName)
                    isPresented = false
                }

                Divider()

                sheetRow(title: StatisticsSortType.byRating.rawValue) {
                    onSelect(.byRating)
                    isPresented = false
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Button {
                isPresented = false
            } label: {
                Text("Закрыть")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.hidden)
        .presentationBackground(.clear)
    }

    private func sheetRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .multilineTextAlignment(.center)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
