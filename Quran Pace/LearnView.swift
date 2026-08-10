import SwiftUI

struct LearnView: View {
    @EnvironmentObject var store: QPStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                QPSectionHeader(title: "Guides", subtitle: "How the book and the reading are put together")
                VStack(spacing: 12) {
                    ForEach(QPCatalog.guides) { guide in
                        NavigationLink(destination: QPGuideDetailView(guide: guide)) {
                            guideCard(guide)
                        }
                        .buttonStyle(PressScaleStyle())
                    }
                }
                NavigationLink(destination: QuizView()) {
                    quizCard
                }
                .buttonStyle(PressScaleStyle())
                NavigationLink(destination: QPGlossaryView()) {
                    glossaryCard
                }
                .buttonStyle(PressScaleStyle())
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Learn")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
    }

    private func guideCard(_ guide: QPGuide) -> some View {
        HStack(spacing: 12) {
            PaceArtImage(name: guide.artName)
                .frame(width: 76, height: 76)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(guide.title)
                    .font(QPTheme.serif(17))
                    .foregroundColor(QPTheme.ink)
                Text(guide.subtitle)
                    .font(QPTheme.text(12))
                    .foregroundColor(QPTheme.inkSoft)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    QPChip(text: "\(guide.minutes) min", tint: QPTheme.gold)
                    if store.state.guidesRead.contains(guide.id) {
                        QPChip(text: "Read", tint: QPTheme.sage)
                    }
                }
            }
            Spacer()
            QPArrow()
        }
        .qpCard(padding: 12)
    }

    private var quizCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(QPTheme.roseSoft).frame(width: 54, height: 54)
                OctoStar(points: 5)
                    .fill(QPTheme.rose)
                    .frame(width: 24, height: 24)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Take the quiz")
                    .font(QPTheme.serif(17))
                    .foregroundColor(QPTheme.ink)
                Text("Ten fresh questions on surahs, parts and terms")
                    .font(QPTheme.text(12))
                    .foregroundColor(QPTheme.inkSoft)
                if store.state.quizRounds > 0 {
                    QPChip(text: "Best \(store.state.quizBest) of 10", tint: QPTheme.rose)
                }
            }
            Spacer()
            QPArrow()
        }
        .qpCard(padding: 12)
    }

    private var glossaryCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(QPTheme.indigoSoft).frame(width: 54, height: 54)
                LearnTabIcon(size: 26, color: QPTheme.indigo)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Glossary")
                    .font(QPTheme.serif(17))
                    .foregroundColor(QPTheme.ink)
                Text("\(QPCatalog.glossary.count) terms of the reader's craft")
                    .font(QPTheme.text(12))
                    .foregroundColor(QPTheme.inkSoft)
            }
            Spacer()
            QPArrow()
        }
        .qpCard(padding: 12)
    }
}

struct QPGuideDetailView: View {
    @EnvironmentObject var store: QPStore
    let guide: QPGuide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PaceArtPlate(name: guide.artName, height: 200)
                Text(guide.subtitle)
                    .font(QPTheme.text(14))
                    .foregroundColor(QPTheme.inkSoft)
                ForEach(Array(guide.sections.enumerated()), id: \.offset) { _, section in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(section.heading)
                            .font(QPTheme.serif(18))
                            .foregroundColor(QPTheme.indigo)
                        Text(section.body)
                            .font(QPTheme.text(14))
                            .foregroundColor(QPTheme.ink.opacity(0.85))
                            .lineSpacing(5)
                    }
                    .qpCard()
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Worth keeping")
                        .font(QPTheme.serif(16))
                        .foregroundColor(QPTheme.gold)
                    ForEach(Array(guide.facts.enumerated()), id: \.offset) { _, fact in
                        HStack(alignment: .top, spacing: 8) {
                            Circle()
                                .fill(QPTheme.gold)
                                .frame(width: 5, height: 5)
                                .padding(.top, 6)
                            Text(fact)
                                .font(QPTheme.text(13))
                                .foregroundColor(QPTheme.inkSoft)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .qpCard()
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(guide.title)
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .onAppear {
            store.markGuideRead(guide.id)
        }
    }
}

struct QPGlossaryView: View {
    @State private var query = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                TextField("Search terms", text: $query)
                    .font(QPTheme.text(14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(QPTheme.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .strokeBorder(QPTheme.line, lineWidth: 1)
                            )
                    )
                ForEach(filtered) { term in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(term.term)
                            .font(QPTheme.serif(16))
                            .foregroundColor(QPTheme.indigo)
                        Text(term.definition)
                            .font(QPTheme.text(13))
                            .foregroundColor(QPTheme.inkSoft)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .qpCard(padding: 13)
                }
            }
            .padding(16)
            .padding(.bottom, 12)
        }
        .background(QPTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Glossary")
                    .font(QPTheme.serif(18))
                    .foregroundColor(QPTheme.ink)
            }
        }
    }

    private var filtered: [QPTerm] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        if q.isEmpty { return QPCatalog.glossary }
        return QPCatalog.glossary.filter {
            $0.term.lowercased().contains(q) || $0.definition.lowercased().contains(q)
        }
    }
}
