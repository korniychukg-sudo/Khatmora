import SwiftUI

struct QuizView: View {
    @EnvironmentObject var store: QPStore
    @State private var questions: [QPQuizQuestion] = []
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
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
    }

    private var startView: some View {
        VStack(spacing: 18) {
            MedallionRosette(tint: QPTheme.rose, petals: 10)
                .frame(width: 110, height: 110)
            Text("Ten questions")
                .font(QPTheme.serif(24))
                .foregroundColor(QPTheme.ink)
            Text("Surah names and meanings, Meccan and Medinan, the openings of the thirty parts, and the reader's terms. Fresh questions every round, each answered with an explanation.")
                .font(QPTheme.text(14))
                .foregroundColor(QPTheme.inkSoft)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            if store.state.quizRounds > 0 {
                QPChip(text: "Personal best: \(store.state.quizBest) of 10", tint: QPTheme.rose)
            }
            Button {
                startRound()
            } label: {
                Text("Begin")
                    .font(QPTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(QPTheme.indigo))
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
                    QPChip(text: "Question \(index + 1) of \(questions.count)", tint: QPTheme.indigo)
                    Spacer()
                    QPChip(text: "\(score) correct", tint: QPTheme.gold)
                }
                if let hint = q.arabicHint {
                    Text(hint)
                        .font(QPTheme.arabic(28))
                        .foregroundColor(QPTheme.indigo)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                }
                Text(q.prompt)
                    .font(QPTheme.serif(19))
                    .foregroundColor(QPTheme.ink)
                    .lineSpacing(3)
                VStack(spacing: 9) {
                    ForEach(Array(q.options.enumerated()), id: \.offset) { i, option in
                        Button {
                            pick(i)
                        } label: {
                            HStack {
                                Text(option)
                                    .font(QPTheme.text(14, .medium))
                                    .foregroundColor(optionText(i, q: q))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if picked != nil && i == q.correctIndex {
                                    QPCheck()
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
                        .font(QPTheme.text(13))
                        .foregroundColor(QPTheme.inkSoft)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .qpCard(padding: 13)
                    Button {
                        next()
                    } label: {
                        Text(index + 1 < questions.count ? "Next question" : "See result")
                            .font(QPTheme.text(15, .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(QPTheme.indigo))
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
                PaceRing(progress: Double(score) / Double(max(1, questions.count)), lineWidth: 8, tint: QPTheme.gold)
                    .frame(width: 120, height: 120)
                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(QPTheme.round(38))
                        .foregroundColor(QPTheme.ink)
                    Text("of \(questions.count)")
                        .font(QPTheme.text(12))
                        .foregroundColor(QPTheme.inkFaint)
                }
            }
            Text(resultLine)
                .font(QPTheme.serif(22))
                .foregroundColor(QPTheme.ink)
            if score == questions.count {
                Text("A perfect round.")
                    .font(QPTheme.text(14))
                    .foregroundColor(QPTheme.gold)
            }
            Button {
                startRound()
            } label: {
                Text("Another round")
                    .font(QPTheme.text(16, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(QPTheme.indigo))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(24)
    }

    private var resultLine: String {
        switch score {
        case 0...3: return "The map takes time"
        case 4...6: return "A fair round"
        case 7...9: return "Well studied"
        default: return "Sound knowledge"
        }
    }

    private func optionFill(_ i: Int, q: QPQuizQuestion) -> Color {
        guard let p = picked else { return QPTheme.card }
        if i == q.correctIndex { return QPTheme.sageSoft }
        if i == p { return QPTheme.roseSoft }
        return QPTheme.card
    }

    private func optionBorder(_ i: Int, q: QPQuizQuestion) -> Color {
        guard let p = picked else { return QPTheme.line }
        if i == q.correctIndex { return QPTheme.sage.opacity(0.6) }
        if i == p { return QPTheme.rose.opacity(0.5) }
        return QPTheme.line
    }

    private func optionText(_ i: Int, q: QPQuizQuestion) -> Color {
        guard let p = picked else { return QPTheme.ink }
        if i == q.correctIndex { return QPTheme.sage }
        if i == p { return QPTheme.rose }
        return QPTheme.inkFaint
    }

    private func pick(_ i: Int) {
        guard picked == nil else { return }
        picked = i
        if i == questions[index].correctIndex {
            score += 1
            QPHaptics.success()
        } else {
            QPHaptics.warm()
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
        questions = QPQuizEngine.makeRound()
        index = 0
        picked = nil
        score = 0
        finished = false
    }
}
