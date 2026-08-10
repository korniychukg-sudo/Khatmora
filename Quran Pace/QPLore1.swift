import Foundation

enum QPLore {
    private static let guidesA: [QPGuide] = [
        QPGuide(
            id: "qg-mushaf",
            title: "How the Mushaf Is Built",
            subtitle: "Why 604 pages",
            artName: "guide-mushaf",
            minutes: 4,
            sections: [
                QPGuideSection(
                    heading: "One book, one layout",
                    body: "A printed copy of the Quran is called a mushaf. The most widely printed edition — the Madani mushaf — sets the text in 604 pages of fifteen lines each, arranged so that pages almost always end on a complete verse. Because millions of copies share this exact layout, page numbers have become a common language: page 293 opens Surat al-Kahf in Istanbul, Jakarta and Chicago alike."
                ),
                QPGuideSection(
                    heading: "Why pages, not chapters",
                    body: "Chapters of the Quran vary enormously — Al-Baqarah runs 48 pages, Al-Kawthar three lines. Verses vary just as widely. The page is the one steady unit: every page is the same fifteen lines of the same script. That is why readers, teachers and this app measure progress in pages — it is the honest yardstick of how much reading actually happened."
                ),
                QPGuideSection(
                    heading: "The numbers in this app",
                    body: "Quran Pace uses the standard counts of the Madani layout: 604 pages, 114 surahs, 30 parts, and 6,236 verses. Tap any page in the Mushaf tab and the app knows which juz it belongs to and which surah is flowing across it."
                ),
                QPGuideSection(
                    heading: "Not a reader, a companion",
                    body: "This app deliberately contains no Quran text. It is the logbook beside your own mushaf — paper or digital, any print you love. You read there; the map, the pace and the record live here."
                )
            ],
            facts: [
                "Mushaf means a bound copy of the Quran.",
                "The Madani layout: 604 pages, 15 lines per page.",
                "Page numbers match across millions of printed copies."
            ]
        ),
        QPGuide(
            id: "qg-juz",
            title: "Juz, Hizb and Rub",
            subtitle: "The thirty parts and their quarters",
            artName: "guide-juz",
            minutes: 4,
            sections: [
                QPGuideSection(
                    heading: "Thirty equal parts",
                    body: "The Quran is divided into thirty parts of nearly equal length, each called a juz — roughly twenty pages in the standard layout. The division is practical, not thematic: it exists so the whole book can be finished in a month at one part a day. Each juz is known by its opening words; the first is Alif Lam Mim, the last is 'Amma."
                ),
                QPGuideSection(
                    heading: "Halves and quarters",
                    body: "Every juz splits into two hizb, and every hizb into four quarters called rub al-hizb. The margins of most mushafs carry small ornaments marking these points. They are the finer gears of pacing: a reader with ten minutes reads a quarter; a reader with an hour reads a full juz."
                ),
                QPGuideSection(
                    heading: "Juz Amma",
                    body: "The thirtieth part — Juz Amma — holds the short surahs most Muslims learn first, from An-Naba to An-Nas. Because its surahs are brief and vivid, it is where children begin and where many adults return to warm up a reading habit."
                ),
                QPGuideSection(
                    heading: "In this app",
                    body: "The Mushaf tab shows all thirty parts as cards with their opening words and a ring that fills as your position moves through them. The page grid marks every juz boundary, so you can see exactly where in the month-shaped structure you stand."
                )
            ],
            facts: [
                "Juz: one of 30 parts, about 20 pages each.",
                "Hizb: half a juz. Rub al-hizb: a quarter of a hizb.",
                "Juz Amma is the 30th part, home of the shortest surahs."
            ]
        ),
        QPGuide(
            id: "qg-khatm",
            title: "What a Khatm Is",
            subtitle: "Reading the whole book, on purpose",
            artName: "guide-khatm",
            minutes: 4,
            sections: [
                QPGuideSection(
                    heading: "The completed reading",
                    body: "Khatm means sealing or completing — reading the Quran from Al-Fatihah to An-Nas, every page, in order. For many Muslims it is a recurring project of a lifetime: some finish once a year, some every Ramadan, some every month. The point is not speed but completeness; no page of the book is left permanently unvisited."
                ),
                QPGuideSection(
                    heading: "An old and human practice",
                    body: "The habit of pacing a khatm is as old as the divisions themselves — the thirty parts exist precisely so a month maps onto the book. Classical readers kept personal routines measured in ajza and ahzab the way runners keep weekly mileage. A khatm is simply a long walk with a map."
                ),
                QPGuideSection(
                    heading: "Starting one here",
                    body: "This app tracks one khatm at a time. Choose a finish date and it computes the honest daily portion, adjusting as you go; or fix a daily page count and it projects your finish. When page 604 turns, the khatm is sealed, celebrated and archived — and the next one can begin."
                ),
                QPGuideSection(
                    heading: "If you fall behind",
                    body: "Every long reading meets slow weeks. The pace engine never scolds; it just redistributes what remains over the days left, or moves the forecast honestly. A khatm interrupted and resumed is a khatm all the same."
                )
            ],
            facts: [
                "Khatm: a complete reading of the whole Quran.",
                "The 30-part division maps the book onto a month.",
                "One page a day completes the book in under two years."
            ]
        )
    ]

    private static let guidesB: [QPGuide] = [
        QPGuide(
            id: "qg-ramadan",
            title: "Ramadan and the Thirty Parts",
            subtitle: "The month the book was made for",
            artName: "guide-ramadan",
            minutes: 4,
            sections: [
                QPGuideSection(
                    heading: "The month of the Quran",
                    body: "The Quran describes Ramadan as the month in which it was sent down, and Muslims answer by reading more of it in that month than in any other. The juz-a-day khatm is the classic Ramadan rhythm: thirty parts, up to thirty nights, one complete reading between the first fast and Eid. In many communities, the nightly tarawih prayers walk through the whole book as well."
                ),
                QPGuideSection(
                    heading: "The arithmetic of a juz a day",
                    body: "A juz is about twenty pages. Split around the five daily prayers, that is four pages at a sitting — a page or two more on the longest parts. Readers who find twenty pages heavy often run a sixty-day khatm across Rajab and Shaban first, arriving in Ramadan already in stride."
                ),
                QPGuideSection(
                    heading: "Planning it in this app",
                    body: "Set your finish date to the expected end of Ramadan and the daily portion computes itself — including the catch-up math when a busy day leaves you short. The status line tells you plainly whether the moon or your bookmark is ahead."
                )
            ],
            facts: [
                "A juz a day finishes the Quran in a month.",
                "Twenty pages spread over five prayers is four pages each.",
                "Many readers warm up with a slower khatm before Ramadan."
            ]
        ),
        QPGuide(
            id: "qg-pace",
            title: "Finding Your Pace",
            subtitle: "The honest arithmetic of habit",
            artName: "guide-pace",
            minutes: 4,
            sections: [
                QPGuideSection(
                    heading: "Small and daily beats big and rare",
                    body: "The tradition is unambiguous: the most beloved practice is the most constant, however small. Two pages every day outperforms a heroic forty every other Saturday — in arithmetic and in what it does to the reader. Two daily pages seal a khatm in under a year; five finish it twice."
                ),
                QPGuideSection(
                    heading: "Attach it to an anchor",
                    body: "Habits hold when tied to something that already happens. After fajr, after work, before sleep — the reading that has an anchor survives busy seasons. Pick the anchor first and the page count second; a portion that fits inside the anchor's minutes is the one that lasts."
                ),
                QPGuideSection(
                    heading: "Reading the pace report",
                    body: "The Today tab shows three honest numbers: what today asks, what you have read, and what the whole khatm needs. The forecast line projects your true average forward — not the plan you meant to keep, the pace you actually keep. Watching the forecast date crawl earlier is the quiet reward of consistency."
                ),
                QPGuideSection(
                    heading: "When life wins a week",
                    body: "Miss days without drama. The plan redistributes; the streak restarts; the book waits. What matters is the return, and the grid makes returning easy — the next unread page is always lit."
                )
            ],
            facts: [
                "Two pages a day completes the Quran in ten months.",
                "Anchored habits outlive motivated ones.",
                "The forecast uses your real average, not your intention."
            ]
        )
    ]

    static let guides: [QPGuide] = guidesA + guidesB + guidesC + guidesD
}
