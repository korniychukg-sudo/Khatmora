import SwiftUI

struct LearnView: View {
    @EnvironmentObject var store: KHStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                KHSectionHeader(title: "Guías", subtitle: "Cómo se organizan el libro y su lectura")
                VStack(spacing: 12) {
                    ForEach(KHCatalog.guides) { guide in
                        NavigationLink(destination: KHGuideDetailView(guide: guide)) {
                            guideCard(guide)
                        }
                        .buttonStyle(PressScaleStyle())
                    }
                }
                NavigationLink(destination: QuizView()) {
                    quizCard
                }
                .buttonStyle(PressScaleStyle())
                NavigationLink(destination: KHGlossaryView()) {
                    glossaryCard
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Aprender")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
    }

    private func guideCard(_ guide: KHGuide) -> some View {
        HStack(spacing: 12) {
            KhatmoraArtImage(name: guide.artName)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.title)
                    .font(KHTheme.serif(17))
                    .foregroundColor(KHTheme.ink)
                Text(guide.subtitle)
                    .font(KHTheme.text(12))
                    .foregroundColor(KHTheme.inkSoft)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    KHChip(text: "\(guide.minutes) min", tint: KHTheme.gold)
                    if store.state.guidesRead.contains(guide.id) {
                        KHChip(text: "Leído", tint: KHTheme.sage)
                    }
                }
            }
            Spacer()
            KHArrow()
        }
        .khCard(padding: 12)
    }

    private var quizCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(KHTheme.roseSoft).frame(width: 54, height: 54)
                OctoStar(points: 5)
                    .fill(KHTheme.rose)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Hacer el cuestionario")
                    .font(KHTheme.serif(17))
                    .foregroundColor(KHTheme.ink)
                Text("Diez preguntas nuevas sobre suras, partes y términos")
                    .font(KHTheme.text(12))
                    .foregroundColor(KHTheme.inkSoft)
                if store.state.quizRounds > 0 {
                    KHChip(text: "Mejor: \(store.state.quizBest) de 10", tint: KHTheme.rose)
                }
            }
            Spacer()
            KHArrow()
        }
        .khCard(padding: 12)
    }

    private var glossaryCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(KHTheme.indigoSoft).frame(width: 54, height: 54)
                LearnTabIcon(size: 26, color: KHTheme.indigo)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Glosario")
                    .font(KHTheme.serif(17))
                    .foregroundColor(KHTheme.ink)
                Text("\(KHCatalog.glossary.count) términos para comprender la lectura")
                    .font(KHTheme.text(12))
                    .foregroundColor(KHTheme.inkSoft)
            }
            Spacer()
            KHArrow()
        }
        .khCard(padding: 12)
    }
}

struct KHGuideDetailView: View {
    @EnvironmentObject var store: KHStore
    let guide: KHGuide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KhatmoraArtPlate(name: guide.artName, height: 200)
                Text(guide.subtitle)
                    .font(KHTheme.text(14))
                    .foregroundColor(KHTheme.inkSoft)
                ForEach(Array(guide.sections.enumerated()), id: \.offset) { _, section in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.heading)
                            .font(KHTheme.serif(18))
                            .foregroundColor(KHTheme.indigo)
                        Text(section.body)
                            .font(KHTheme.text(14))
                            .foregroundColor(KHTheme.ink.opacity(0.85))
                            .lineSpacing(5)
                    }
                    .khCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Para recordar")
                        .font(KHTheme.serif(16))
                        .foregroundColor(KHTheme.gold)
                    ForEach(Array(guide.facts.enumerated()), id: \.offset) { _, fact in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(KHTheme.gold)
                                .frame(width: 5, height: 5)
                                .padding(.top, 6)
                            Text(fact)
                                .font(KHTheme.text(13))
                                .foregroundColor(KHTheme.inkSoft)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .khCard()
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(guide.title)
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .onAppear {
            store.markGuideRead(guide.id)
        }
    }
}

struct KHGlossaryView: View {
    @State private var query = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                TextField("Buscar términos", text: $query)
                    .font(KHTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(KHTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(KHTheme.line, lineWidth: 1)
                            )
                    )
                ForEach(filtered) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(KHTheme.serif(16))
                            .foregroundColor(KHTheme.indigo)
                        Text(term.definition)
                            .font(KHTheme.text(13))
                            .foregroundColor(KHTheme.inkSoft)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .khCard(padding: 13)
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(KHTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Glosario")
                    .font(KHTheme.serif(18))
                    .foregroundColor(KHTheme.ink)
            }
        }
    }

    private var filtered: [KHTerm] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return KHCatalog.glossary }
        return KHCatalog.glossary.filter {
            $0.term.lowercased().contains(q) || $0.definition.lowercased().contains(q)
        }
    }
}
