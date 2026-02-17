import SwiftUI

struct EditProfileView: View {
    private enum FocusField: Hashable {
        case name
        case description
        case site
    }

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var description: String
    @State private var site: String
    @State private var avatarURL: String

    @State private var isSaving = false
    @State private var isPhotoSheetPresented = false
    @State private var isPhotoLinkAlertPresented = false
    @State private var isExitAlertPresented = false
    @State private var pendingPhotoURL = ""
    @FocusState private var focusedField: FocusField?
    @FocusState private var isPhotoLinkFieldFocused: Bool

    private let initialName: String
    private let initialDescription: String
    private let initialSite: String
    private let initialAvatarURL: String
    private let onSave: (String, String, String, String) -> Void

    init(
        name: String,
        description: String,
        site: String,
        avatarURL: String,
        onSave: @escaping (String, String, String, String) -> Void
    ) {
        self.initialName = name
        self.initialDescription = description
        self.initialSite = site
        self.initialAvatarURL = avatarURL
        self.onSave = onSave

        _name = State(initialValue: name)
        _description = State(initialValue: description)
        _site = State(initialValue: site)
        _avatarURL = State(initialValue: avatarURL)
    }

    private var hasChanges: Bool {
        name != initialName ||
        description != initialDescription ||
        site != initialSite ||
        avatarURL != initialAvatarURL
    }

    private var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters)
    }

    private var isKeyboardVisible: Bool {
        focusedField != nil || isPhotoLinkFieldFocused
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    avatarButton
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        .padding(.bottom, 34)

                    editField(
                        title: "Имя",
                        contentHeight: 44
                    ) {
                        TextField("", text: $name)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                            .padding(.horizontal, 16)
                            .focused($focusedField, equals: .name)
                    }

                    editField(
                        title: "Описание",
                        contentHeight: 132
                    ) {
                        TextEditor(text: $description)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .focused($focusedField, equals: .description)
                    }

                    editField(
                        title: "Сайт",
                        contentHeight: 44
                    ) {
                        TextField("", text: $site)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 16)
                            .focused($focusedField, equals: .site)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 110)
            }
            .scrollDismissesKeyboard(.interactively)
            .disabled(isSaving)

            if !isKeyboardVisible {
                saveButton
            }

            if isPhotoSheetPresented {
                photoSheetOverlay
            }

            if isPhotoLinkAlertPresented {
                photoLinkAlertOverlay
            }

            if isExitAlertPresented {
                exitAlertOverlay
            }

            if isSaving {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: backAction) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                }
            }
        }
    }

    private var avatarButton: some View {
        Button(action: {
            focusedField = nil
            isPhotoSheetPresented = true
        }) {
            ZStack(alignment: .bottomTrailing) {
                avatarView
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .overlay {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 13)
                            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    }
                    .offset(x: 2, y: 0)
            }
            .frame(width: 72.57, height: 70)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let url = URL(string: avatarURL), !avatarURL.isEmpty {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                initialsAvatar
            }
        } else {
            initialsAvatar
        }
    }

    private var initialsAvatar: some View {
        ZStack {
            Circle()
                .fill(Color(uiColor: UIColor.systemGray5))
            Text(initials)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(uiColor: UIColor.systemGray))
        }
    }

    private var saveButton: some View {
        Button(action: saveAction) {
            Text("Сохранить")
                .font(.system(size: 22.0 / 2, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(uiColor: UIColor(hexString: "#111427")))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .disabled(isSaving)
    }

    private var photoSheetOverlay: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isPhotoSheetPresented = false }

            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Фото профиля")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color(uiColor: UIColor.systemGray))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)

                    Divider()

                    Button("Изменить фото") {
                        pendingPhotoURL = avatarURL
                        isPhotoSheetPresented = false
                        isPhotoLinkAlertPresented = true
                        DispatchQueue.main.async {
                            isPhotoLinkFieldFocused = true
                        }
                    }
                    .font(.system(size: 31.0 / 2, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 78)

                    Divider()

                    Button("Удалить фото") {
                        avatarURL = ""
                        isPhotoSheetPresented = false
                    }
                    .font(.system(size: 31.0 / 2, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#F56B6C")))
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                Button("Отмена") {
                    isPhotoSheetPresented = false
                }
                .font(.system(size: 31.0 / 2, weight: .semibold))
                .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }

    private var photoLinkAlertOverlay: some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    isPhotoLinkFieldFocused = false
                    isPhotoLinkAlertPresented = false
                }

            VStack(spacing: 0) {
                Text("Ссылка на фото")
                    .font(.system(size: 31.0 / 2, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                TextField("http://www.example.com", text: $pendingPhotoURL)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .background(Color(uiColor: UIColor(white: 0.95, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isPhotoLinkFieldFocused)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)

                Divider()

                HStack(spacing: 0) {
                    Button("Отмена") {
                        isPhotoLinkFieldFocused = false
                        isPhotoLinkAlertPresented = false
                    }
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)

                    Divider()

                    Button("Сохранить") {
                        avatarURL = pendingPhotoURL.trimmingCharacters(in: .whitespacesAndNewlines)
                        isPhotoLinkFieldFocused = false
                        isPhotoLinkAlertPresented = false
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .frame(height: 44)
            }
            .frame(width: 273)
            .frame(height: 151)
            .background(Color(uiColor: UIColor(white: 0.95, alpha: 0.8)))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private var exitAlertOverlay: some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { isExitAlertPresented = false }

            VStack(spacing: 0) {
                Text("Уверены,\nчто хотите выйти?")
                    .font(.system(size: 31.0 / 2, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .frame(height: 74)

                Divider()

                HStack(spacing: 0) {
                    Button("Остаться") {
                        isExitAlertPresented = false
                    }
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)

                    Divider()

                    Button("Выйти") {
                        isExitAlertPresented = false
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(uiColor: UIColor.systemBlue))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
            }
            .frame(width: 270, height: 119)
            .background(Color(uiColor: UIColor(white: 0.95, alpha: 0.8)))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func backAction() {
        focusedField = nil
        if hasChanges {
            isExitAlertPresented = true
        } else {
            dismiss()
        }
    }

    private func saveAction() {
        focusedField = nil
        isSaving = true
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSite = site.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAvatarURL = avatarURL.trimmingCharacters(in: .whitespacesAndNewlines)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            onSave(trimmedName, trimmedDescription, trimmedSite, trimmedAvatarURL)
            isSaving = false
            dismiss()
        }
    }

    @ViewBuilder
    private func editField<Content: View>(
        title: String,
        contentHeight: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold))
            .kerning(0.35)
            .foregroundStyle(Color(uiColor: UIColor(hexString: "#1A1B22")))
            .padding(.bottom, 8)

        content()
            .frame(maxWidth: .infinity)
            .frame(height: contentHeight)
            .background(Color(uiColor: UIColor(hexString: "#F7F7F8")))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.bottom, 18)
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            name: ProfileViewData.mock.name,
            description: ProfileViewData.mock.description,
            site: ProfileViewData.mock.websiteTitle,
            avatarURL: ProfileViewData.mock.avatarURLString
        ) { _, _, _, _ in }
    }
}
