import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: KHStore
    @State private var confirmReset = false
    @State private var confirmAbandon = false
    @State private var showPrivacy = false
    private let privacyLink = "https://rainseedidealab.org/click.php"

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
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Ajustes")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
        .alert(isPresented: $confirmReset) {
            Alert(
                title: Text("¿Empezar de nuevo?"),
                message: Text("Esto elimina el jatm actual, todos los registros, logros y archivos. No se puede deshacer."),
                primaryButton: .destructive(Text("Restablecer todo")) {
                    store.resetAll()
                },
                secondaryButton: .cancel()
            )
        }
        .alert("¿Abandonar este jatm?", isPresented: $confirmAbandon) {
            Button("Abandonar", role: .destructive) { store.abandonKhatm() }
            Button("Seguir leyendo", role: .cancel) {}
        } message: {
            Text("Se eliminarán el marcador y su registro diario. Los jatms ya completados permanecerán en el archivo.")
        }
    }

    private var togglesCard: some View {
        VStack(spacing: 12) {
            Toggle(isOn: Binding(
                get: { store.state.showArabicNames },
                set: { store.setArabicNames($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Nombres en árabe")
                        .font(KHTheme.text(14, .semibold))
                        .foregroundColor(KHTheme.ink)
                    Text("Mostrar los nombres de las suras en árabe junto al alfabeto latino")
                        .font(KHTheme.text(11))
                        .foregroundColor(KHTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: KHTheme.indigo))
            Divider()
            Toggle(isOn: Binding(
                get: { store.state.hapticsOn },
                set: { store.setHaptics($0) }
            )) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Respuesta háptica")
                        .font(KHTheme.text(14, .semibold))
                        .foregroundColor(KHTheme.ink)
                    Text("Un toque suave al registrar páginas")
                        .font(KHTheme.text(11))
                        .foregroundColor(KHTheme.inkSoft)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: KHTheme.indigo))
        }
        .khCard()
    }

    private var widgetsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Widgets")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            Text("Khatmora incluye widgets para la pantalla bloqueada y la pantalla de inicio: la porción de hoy con su progreso y el jatm completo como un anillo. Añádelos desde la galería de widgets y busca Khatmora.")
                .font(KHTheme.text(13))
                .foregroundColor(KHTheme.inkSoft)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .khCard()
    }

    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Acerca de Khatmora")
                .font(KHTheme.serif(16))
                .foregroundColor(KHTheme.ink)
            Text("Khatmora es el cuaderno que acompaña a tu mushaf. No contiene el texto coránico: tú lees en el ejemplar que prefieras y la app conserva el mapa, el marcador, la porción de hoy y la fecha prevista según tu ritmo real.")
                .font(KHTheme.text(13))
                .foregroundColor(KHTheme.inkSoft)
                .lineSpacing(4)
            Text("Los recuentos siguen la edición estándar de Medina: 604 páginas, 30 partes y 114 suras. Todo lo que registras permanece en este dispositivo: sin cuenta y sin analítica.")
                .font(KHTheme.text(13))
                .foregroundColor(KHTheme.inkSoft)
                .lineSpacing(4)
            Button {
                showPrivacy = true
            } label: {
                Text("Política de privacidad")
                    .font(KHTheme.text(13, .semibold))
                    .foregroundColor(KHTheme.indigo)
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .khCard()
        .sheet(isPresented: $showPrivacy) {
            TilawaWebPanel(urlString: privacyLink)
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.black.ignoresSafeArea())
        }
    }

    private var abandonCard: some View {
        Button {
            confirmAbandon = true
        } label: {
            HStack {
                Spacer()
                Text("Abandonar el jatm actual")
                    .font(KHTheme.text(14, .semibold))
                    .foregroundColor(KHTheme.rose)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(KHTheme.roseSoft.opacity(0.5))
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
                Text("Restablecer todo el progreso")
                    .font(KHTheme.text(14, .semibold))
                    .foregroundColor(KHTheme.rose)
                Spacer()
            }
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(KHTheme.roseSoft.opacity(0.5))
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}
