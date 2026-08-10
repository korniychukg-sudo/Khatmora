import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: QPStore
    @State private var confirmReset = false
    @State private var confirmAbandon = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                togglesCard
                widgetsCard
                aboutCard
                if store.state.plan != nil {
                    abandonCard
                }
                resetCard
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
        .alert(isPresented: $confirmReset) {
            Alert(
                title: Text("Start over?"),
                message: Text("This clears the current khatm, every record, badge and archive. It cannot be undone."),
                primaryButton: .destructive(Text("Reset everything")) {
                    store.resetAll()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("Abandon this khatm?", isPresented: $confirmAbandon) {
            Button("Abandon", role: .destructive) { store.abandonKhatm() }
            Button("Keep reading", role: .cancel) {}
        } message: {
            Text("The bookmark and its daily log are discarded. Sealed khatms in the archive stay.")
        }
    }

    private var togglesCard: some View {
        VStack(spacing: 12) {
            Toggle(isOn: Binding(
                get: { store.state.showArabicNames },
                set: { store.setArabicNames($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Arabic names")
                        .font(QPTheme.text(14, .semibold))
                        .foregroundColor(QPTheme.ink)
                    Text("Show surah names in Arabic script beside the Latin")
                        .font(QPTheme.text(11))
                        .foregroundColor(QPTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: QPTheme.indigo))
            Divider()
            Toggle(isOn: Binding(
                get: { store.state.hapticsOn },
                set: { store.setHaptics($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Haptics")
                        .font(QPTheme.text(14, .semibold))
                        .foregroundColor(QPTheme.ink)
                    Text("A soft tick when pages are logged")
                        .font(QPTheme.text(11))
                        .foregroundColor(QPTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: QPTheme.indigo))
        }
        .qpCard()
    }

    private var widgetsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Widgets")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            Text("Quran Pace carries widgets for the Lock Screen and Home Screen: today's portion with its progress, and the whole khatm as a filling ring. Add them from the widget gallery — long-press the Lock or Home Screen, tap the add button, and search for Quran Pace.")
                .font(QPTheme.text(13))
                .foregroundColor(QPTheme.inkSoft)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About Quran Pace")
                .font(QPTheme.serif(16))
                .foregroundColor(QPTheme.ink)
            Text("Quran Pace is the logbook beside your own mushaf. It holds no Quran text — you read from the copy you love, and this app keeps the map: where the bookmark stands, what today asks, and when the khatm will be sealed at your true pace.")
                .font(QPTheme.text(13))
                .foregroundColor(QPTheme.inkSoft)
                .lineSpacing(4)
            Text("Counts follow the standard Madani layout: 604 pages, 30 parts, 114 surahs. Everything lives on this device — no account, no network, nothing leaves your phone.")
                .font(QPTheme.text(13))
                .foregroundColor(QPTheme.inkSoft)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .qpCard()
    }

    private var abandonCard: some View {
        Button {
            confirmAbandon = true
        } label: {
            HStack {
                Spacer()
                Text("Abandon current khatm")
                    .font(QPTheme.text(14, .semibold))
                    .foregroundColor(QPTheme.rose)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(QPTheme.roseSoft.opacity(0.5))
            )
        }
        .buttonStyle(PressScaleStyle())
    }

    private var resetCard: some View {
        Button {
            confirmReset = true
        } label: {
            HStack {
                Spacer()
                Text("Reset all progress")
                    .font(QPTheme.text(14, .semibold))
                    .foregroundColor(QPTheme.rose)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(QPTheme.roseSoft.opacity(0.5))
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}
