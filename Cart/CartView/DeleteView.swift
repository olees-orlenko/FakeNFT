//
//  DeleteView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Игнат Рогачевич on 11.02.26.
//

import SwiftUI

struct DeleteView: View {
    let onDelete: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack {
            Image("April")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 108, height: 108)
            Text("Вы уверены,что хотите \nудалить этот объект из корзины?")
                .foregroundStyle(.blackAdaptive)
                .font(.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            HStack(alignment: .center, spacing: 8) {
                Button(action: onDelete) {
                    Text("Удалить")
                        .foregroundStyle(.ypRed)
                }
                .frame(width: 127)
                .padding()
                .background(.blackAdaptive)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button(action: onCancel) {
                    Text("Вернуться")
                        .foregroundStyle(.whiteAdaptive)
                }
                .frame(width: 127)
                .padding()
                .background(.blackAdaptive)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

#Preview ("Delete view light") {
    DeleteView(onDelete: {}, onCancel: {})
        .preferredColorScheme(.light)
}

#Preview("Delete view dark") {
    DeleteView(onDelete: {}, onCancel: {})
        .preferredColorScheme(.dark)
}
