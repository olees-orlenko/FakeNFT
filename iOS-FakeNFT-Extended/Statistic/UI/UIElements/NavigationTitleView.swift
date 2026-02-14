import SwiftUI

struct NavigationTitleView: View {
    
    enum ButtonPosition {
        case left
        case right
        case none
    }
    
    enum TitleAlignment {
        case center
        case leading
        case trailing
    }
    
    let title: String?
    let systemImage: String?
    let buttonPosition: ButtonPosition
    let titleAlignment: TitleAlignment
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            
            if buttonPosition == .left, let systemImage {
                button(image: systemImage)
            } else if titleAlignment == .center && buttonPosition == .right {
                spacerPlaceholder
            }
            
            titleView
            
            if buttonPosition == .right, let systemImage {
                button(image: systemImage)
            } else if titleAlignment == .center && buttonPosition == .left {
                spacerPlaceholder
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 42)
    }
    
    // MARK: - Title Logic
    
    @ViewBuilder
    private var titleView: some View {
        switch titleAlignment {
            
        case .center:
            Spacer()
            if let title {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(UIColor.textPrimary))
            }
            Spacer()
            
        case .leading:
            if let title {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(UIColor.textPrimary))
            }
            Spacer()
            
        case .trailing:
            Spacer()
            if let title {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(UIColor.textPrimary))
            }
        }
    }
    
    // MARK: - Button
    
    private func button(image: String) -> some View {
        Button {
            onTap?()
        } label: {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(UIColor.segmentActive))
        }
        .buttonStyle(.plain)
    }
    
    private var spacerPlaceholder: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 20, height: 20)
    }
}

#Preview {
    let title = NSLocalizedString("Statistic.nftCollectionTitle", comment: "")
    
    return VStack(spacing: 20) {
        
        NavigationTitleView(
            title: title,
            systemImage: "chevron.left",
            buttonPosition: .left,
            titleAlignment: .center
        )
        
        NavigationTitleView(
            title: title,
            systemImage: "chevron.right",
            buttonPosition: .right,
            titleAlignment: .leading
        )
        
        NavigationTitleView(
            title: nil,
            systemImage: "chevron.right",
            buttonPosition: .right,
            titleAlignment: .center
        )
        
        NavigationTitleView(
            title: nil,
            systemImage: "list.bullet",
            buttonPosition: .right,
            titleAlignment: .center
        )
    }
    .padding()
    .background(Color(UIColor.background))
}
