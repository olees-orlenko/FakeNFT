import SwiftUI

struct ProfileRowView: View {
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Text("\(title) (\(count))")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .closeButton))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(uiColor: .closeButton))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
    }
}
