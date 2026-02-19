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

    let assetImage: String?

    let buttonPosition: ButtonPosition
    let titleAlignment: TitleAlignment
    var onTap: (() -> Void)? = nil

    init(
        title: String?,
        systemImage: String? = nil,
        assetImage: String? = nil,
        buttonPosition: ButtonPosition,
        titleAlignment: TitleAlignment,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.assetImage = assetImage
        self.buttonPosition = buttonPosition
        self.titleAlignment = titleAlignment
        self.onTap = onTap
    }

    var body: some View {
        HStack {

            if buttonPosition == .left {
                buttonView
            } else if titleAlignment == .center && buttonPosition == .right {
                spacerPlaceholder
            }

            titleView

            if buttonPosition == .right {
                buttonView
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

    @ViewBuilder
    private var buttonView: some View {
        if systemImage != nil || assetImage != nil {
            Button { onTap?() } label: {
                imageView
            }
            .buttonStyle(.plain)
        } else {
            spacerPlaceholder
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(UIColor.segmentActive))
        } else if let assetImage {
            Image(assetImage)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .contentShape(Rectangle())
        }
    }

    private var spacerPlaceholder: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: placeholderSize, height: placeholderSize)
    }

    private var placeholderSize: CGFloat {
        assetImage == nil ? 20 : 42
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
            assetImage: "Light",
            buttonPosition: .right,
            titleAlignment: .center
        )
    }
    .padding()
    .background(Color(UIColor.background))
}
