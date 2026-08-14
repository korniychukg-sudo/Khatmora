import SwiftUI

struct QuizView: View {
    @EnvironmentObject var store: KHStore
    @State private var questions: [KHQuizQuestion] = []
    @State private var index = 0
    @State private var picked: Int? = nil
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        Group {
            if finished {
                resultView
            } else if questions.isEmpty {
                startView
            } else {
                questionView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Cuestionario")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
    }

    private var startView: some View {
        VStack(spacing: 18) {
            MedallionRosette(tint: KHTheme.rose, petals: 10)
                .frame(width: 110, height: 110)
            Text("Diez preguntas")
                .font(KHTheme.serif(24))
                .foregroundColor(KHTheme.ink)
            Text("Nombres y significados de las suras, revelaciones mecanas y medinenses, comienzos de las treinta partes y términos de lectura. Cada ronda ofrece preguntas nuevas con una explicación para cada respuesta.")
                .font(KHTheme.text(14))
                .foregroundColor(KHTheme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            if store.state.quizRounds > 0 {
                KHChip(text: "Mejor marca: \(store.state.quizBest) de 10", tint: KHTheme.rose)
            }
            Button {
                startRound()
            } label: {
                Text("Comenzar")
                    .font(KHTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(20)
    }

    private var questionView: some View {
        let q = questions[index]
        return ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    KHChip(text: "Pregunta \(index + 1) de \(questions.count)", tint: KHTheme.indigo)
                    Spacer()
                    KHChip(text: "\(score) correctas", tint: KHTheme.gold)
                }
                if let hint = q.arabicHint {
                    Text(hint)
                        .font(KHTheme.arabic(28))
                        .foregroundColor(KHTheme.indigo)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }
                Text(q.prompt)
                    .font(KHTheme.serif(19))
                    .foregroundColor(KHTheme.ink)
                    .lineSpacing(3)
                VStack(spacing: 9) {
                    ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                        Button {
                            pick(i)
                        } label: {
                            HStack {
                                Text(option)
                                    .font(KHTheme.text(14, .medium))
                                    .foregroundColor(optionText(i, q: q))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if picked != nil && i == q.correctIndex {
                                    KHCheck()
                                }
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(optionFill(i, q: q))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                                            .strokeBorder(optionBorder(i, q: q), lineWidth: 1.2)
                                    )
                            )
                        }
                        .buttonStyle(PressScaleStyle())
                        .disabled(picked != nil)
                    }
                }
                if picked != nil {
                    Text(q.explanation)
                        .font(KHTheme.text(13))
                        .foregroundColor(KHTheme.inkSoft)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .khCard(padding: 13)
                    Button {
                        next()
                    } label: {
                        Text(index + 1 < questions.count ? "Siguiente pregunta" : "Ver resultado")
                            .font(KHTheme.text(15, .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(KHTheme.indigo))
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
    }

    private var resultView: some View {
        VStack(spacing: 16) {
            ZStack {
                KhatmoraRing(progress: Double(score) / Double(max(1, questions.count)), lineWidth: 8, tint: KHTheme.gold)
                    .frame(width: 120, height: 120)
                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(KHTheme.round(38))
                        .foregroundColor(KHTheme.ink)
                    Text("de \(questions.count)")
                        .font(KHTheme.text(12))
                        .foregroundColor(KHTheme.inkFaint)
                }
            }
            Text(resultLine)
                .font(KHTheme.serif(22))
                .foregroundColor(KHTheme.ink)
            if score == questions.count {
                Text("Una ronda perfecta.")
                    .font(KHTheme.text(14))
                    .foregroundColor(KHTheme.gold)
            }
            Button {
                startRound()
            } label: {
                Text("Otra ronda")
                    .font(KHTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(KHTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(24)
    }

    private var resultLine: String {
        switch score {
        case 0...3: return "El mapa requiere tiempo"
        case 4...6: return "Una ronda correcta"
        case 7...9: return "Muy bien estudiado"
        default: return "Buen conocimiento"
        }
    }

    private func optionFill(_ i: Int, q: KHQuizQuestion) -> Color {
        guard let p = picked else { return KHTheme.card }
        if i == q.correctIndex { return KHTheme.sageSoft }
        if i == p { return KHTheme.roseSoft }
        return KHTheme.card
    }

    private func optionBorder(_ i: Int, q: KHQuizQuestion) -> Color {
        guard let p = picked else { return KHTheme.line }
        if i == q.correctIndex { return KHTheme.sage.opacity(0.6) }
        if i == p { return KHTheme.rose.opacity(0.5) }
        return KHTheme.line
    }

    private func optionText(_ i: Int, q: KHQuizQuestion) -> Color {
        guard let p = picked else { return KHTheme.ink }
        if i == q.correctIndex { return KHTheme.sage }
        if i == p { return KHTheme.rose }
        return KHTheme.inkFaint
    }

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        if i == questions[index].correctIndex {
            score += 1
            KHHaptics.success()
        } else {
            KHHaptics.warm()
        }
    }

    private func next() {
        if index + 1 < questions.count {
            index += 1
            picked = nil
        } else {
            store.quizFinished(score: score, total: questions.count)
            finished = true
        }
    }

    private func startRound() {
        questions = KHQuizEngine.makeRound()
        index = 0
        picked = nil
        score = 0
        finished = false
    }
}
