import SwiftUI

struct ProfileRowView: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text("\(title) (\(count))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(.systemGray2))
        }
        .frame(height: 54)
        .padding(.horizontal, 16)
    }
}
