import Foundation

extension KHLore {
    static let guidesC: [KHGuide] = [
        KHGuide(
            id: "qg-surah",
            title: "Surah and Ayah",
            subtitle: "The book's own units",
            artName: "guide-surah",
            minutes: 4,
            sections: [
                KHGuideSection(
                    heading: "One hundred and fourteen",
                    body: "The Quran contains 114 surahs, from Al-Baqarah's 286 verses to three-verse Al-Kawthar. Surah is often translated chapter, but the surahs are not chapters of a narrative — each is a complete composition with its own name, voice and concerns, named after a striking image within it: The Cow, The Bee, The Star, The Daybreak."
                ),
                KHGuideSection(
                    heading: "The verse and its count",
                    body: "A single unit of the text is an ayah — literally a sign. The standard Kufan count used in most printed mushafs numbers 6,236 ayahs in all. Verse length swings from two words to a full page, which is why serious pacing counts pages rather than verses."
                ),
                KHGuideSection(
                    heading: "Longest first, mostly",
                    body: "After the opening Al-Fatihah, the surahs run roughly from longest to shortest — an arrangement by weight, not by date of revelation. A khatm therefore starts in the long Medinan legislative surahs and ends among the short early Meccan ones, so the reading grows lighter as the bookmark travels."
                ),
                KHGuideSection(
                    heading: "The Surahs tab",
                    body: "All 114 are listed with their Arabic name, meaning, verse count, origin and starting page. Tap one to jump your bookmark to it, or to see how far through it your position stands."
                )
            ],
            facts: [
                "114 surahs; 6,236 ayahs in the standard count.",
                "Ayah means sign.",
                "After Al-Fatihah the order runs roughly longest to shortest."
            ]
        ),
        KHGuide(
            id: "qg-makki",
            title: "Meccan and Medinan",
            subtitle: "Two cities, two registers",
            artName: "guide-makki",
            minutes: 4,
            sections: [
                KHGuideSection(
                    heading: "A revelation in two eras",
                    body: "The Quran came down across twenty-three years split by one journey: the migration from Mecca to Medina. Surahs revealed before it are called Meccan — 86 of them; those after, Medinan — 28. Most mushafs print the designation beside each surah's name."
                ),
                KHGuideSection(
                    heading: "How they differ",
                    body: "Meccan surahs are typically short-versed and thunderous: God's oneness, the resurrection, the fates of vanished nations. Medinan surahs stretch out to govern an actual community — inheritance, contracts, family law, treaties. The difference is audible within a page: recognizing it turns a long reading into a journey with distinct landscapes."
                ),
                KHGuideSection(
                    heading: "Why it helps a khatm",
                    body: "Knowing the register ahead helps pacing. The early juz are dense Medinan legislation that rewards a slower, morning mind. From roughly the middle of the book the Meccan voice dominates and pages turn faster. Plan heavy days accordingly."
                )
            ],
            facts: [
                "86 surahs are Meccan, 28 Medinan in the standard reckoning.",
                "Meccan: creed and the hereafter. Medinan: law and community.",
                "The book's first half is heavier reading than its last."
            ]
        ),
        KHGuide(
            id: "qg-tilawah",
            title: "The Etiquette of Reading",
            subtitle: "Adab of tilawah",
            artName: "guide-tilawah",
            minutes: 4,
            sections: [
                KHGuideSection(
                    heading: "Before the first word",
                    body: "Reading the Quran traditionally begins with seeking refuge — a'udhu billahi minash-shaytanir-rajim — followed by bismillah at the head of every surah except At-Tawbah. Readers prefer a clean state, a clean place, and an unhurried minute; the book is approached, not grabbed."
                ),
                KHGuideSection(
                    heading: "Measured, not raced",
                    body: "The Quran itself commands: recite it with tartil — slow, measured cadence. The science of pronouncing every letter correctly is tajwid, learned mouth-to-mouth from teachers. A khatm is not a speed run; a page read with care outweighs a juz skimmed."
                ),
                KHGuideSection(
                    heading: "Stopping and returning",
                    body: "Classical readers close a session at a sensible stopping place and mark it — the original bookmark. Returning tomorrow to the exact page is half the discipline of a khatm, and precisely the half this app carries for you."
                ),
                KHGuideSection(
                    heading: "The prostration verses",
                    body: "Fifteen places in the mushaf carry a small marker where the reader traditionally performs a prostration of recitation. Most printings flag them in the margin — one more reason readers grow attached to a particular physical mushaf."
                )
            ],
            facts: [
                "Tartil: slow, measured recitation, commanded in the text itself.",
                "Tajwid is learned from teachers, not only books.",
                "Fifteen verses of prostration are marked in the margins."
            ]
        )
    ]

    static let guidesD: [KHGuide] = [
        KHGuide(
            id: "qg-memory",
            title: "Keeping the Habit",
            subtitle: "From first page to sealed book",
            artName: "guide-memory",
            minutes: 4,
            sections: [
                KHGuideSection(
                    heading: "The plateau in the middle",
                    body: "Most abandoned khatms die between juz eight and juz eighteen — far from the excitement of starting, far from the pull of finishing. Expect the plateau. Shrink the portion if needed; a khatm that slows is alive, one that stops for a month is in danger."
                ),
                KHGuideSection(
                    heading: "Tie reading to reward",
                    body: "The grid fills, the juz rings close, the forecast date walks backward — these are honest rewards, and they work. Check the Mushaf tab after each session and let the map show what the day added. Progress made visible is progress repeated."
                ),
                KHGuideSection(
                    heading: "Read with company",
                    body: "Households and study circles have always run collective khatms — each member carrying some parts, the whole book sealed together. Even alone, telling one person about your target date roughly doubles the odds of meeting it."
                ),
                KHGuideSection(
                    heading: "After the seal",
                    body: "Tradition treats the completion as a moment of answered prayer, and many readers begin the next khatm the same day — reciting Al-Fatihah and the opening of Al-Baqarah so the book never quite closes. The archive in your Journal keeps every sealed reading; the button for the next one is right beside it."
                )
            ],
            facts: [
                "Khatms most often stall in the middle third.",
                "Visible progress is the strongest everyday motivator.",
                "Many readers open the next khatm the day one is sealed."
            ]
        )
    ]

    private static let glossaryA: [KHTerm] = [
        KHTerm(id: "qt-mushaf", term: "Mushaf", definition: "A physical copy of the Quran; this app follows the standard 604-page Madani layout."),
        KHTerm(id: "qt-juz", term: "Juz", definition: "One of thirty near-equal parts of the Quran, about twenty pages each."),
        KHTerm(id: "qt-hizb", term: "Hizb", definition: "Half of a juz; sixty in the whole book."),
        KHTerm(id: "qt-rub", term: "Rub al-hizb", definition: "A quarter of a hizb, marked by a small ornament in most mushaf margins."),
        KHTerm(id: "qt-surah", term: "Surah", definition: "One of the 114 named compositions of the Quran."),
        KHTerm(id: "qt-ayah", term: "Ayah", definition: "A single verse; literally a sign. The standard count totals 6,236."),
        KHTerm(id: "qt-khatm", term: "Khatm", definition: "A complete reading of the Quran from beginning to end."),
        KHTerm(id: "qt-tilawah", term: "Tilawah", definition: "The act of reciting the Quran."),
        KHTerm(id: "qt-tartil", term: "Tartil", definition: "Slow, measured recitation, commanded in the Quran itself."),
        KHTerm(id: "qt-tajwid", term: "Tajwid", definition: "The science of pronouncing every letter of recitation correctly.")
    ]

    private static let glossaryB: [KHTerm] = [
        KHTerm(id: "qt-juzamma", term: "Juz Amma", definition: "The thirtieth juz, containing the short final surahs; most memorization begins here."),
        KHTerm(id: "qt-fatihah", term: "Al-Fatihah", definition: "The seven-verse opening surah, recited in every unit of the prayer."),
        KHTerm(id: "qt-makki", term: "Meccan", definition: "A surah revealed before the migration to Medina; 86 surahs are Meccan."),
        KHTerm(id: "qt-madani", term: "Medinan", definition: "A surah revealed after the migration; typically longer and legislative."),
        KHTerm(id: "qt-hafiz", term: "Hafiz", definition: "Someone who has memorized the entire Quran."),
        KHTerm(id: "qt-hifz", term: "Hifz", definition: "The discipline of memorizing the Quran."),
        KHTerm(id: "qt-qari", term: "Qari", definition: "A trained reciter of the Quran."),
        KHTerm(id: "qt-basmalah", term: "Basmalah", definition: "The formula bismillahir-rahmanir-rahim that opens every surah except At-Tawbah."),
        KHTerm(id: "qt-istiadhah", term: "Isti'adhah", definition: "Seeking refuge in Allah from Shaytan, said before beginning recitation."),
        KHTerm(id: "qt-sajdah", term: "Sajdat at-tilawah", definition: "The prostration of recitation, marked at fifteen places in the mushaf.")
    ]

    private static let glossaryC: [KHTerm] = [
        KHTerm(id: "qt-wird", term: "Wird", definition: "A fixed personal daily portion of reading or remembrance."),
        KHTerm(id: "qt-waqf", term: "Waqf", definition: "A stopping point in recitation; small letters above the text mark where pausing is preferred."),
        KHTerm(id: "qt-tarawih", term: "Tarawih", definition: "The long nightly Ramadan prayers, in which many mosques recite the whole Quran across the month."),
        KHTerm(id: "qt-madani-mushaf", term: "Madani mushaf", definition: "The most widely printed Quran edition: 604 pages, 15 lines per page."),
        KHTerm(id: "qt-riwayah", term: "Riwayah", definition: "A transmitted reading tradition of the text; Hafs from Asim is the most widespread."),
        KHTerm(id: "qt-tafsir", term: "Tafsir", definition: "Commentary and explanation of the Quran's meanings."),
        KHTerm(id: "qt-eid", term: "Eid al-Fitr", definition: "The festival that ends Ramadan — a common khatm finish line."),
        KHTerm(id: "qt-laylat", term: "Laylat al-Qadr", definition: "The Night of Decree in Ramadan, when the Quran's revelation began."),
        KHTerm(id: "qt-ajza", term: "Ajza", definition: "The plural of juz."),
        KHTerm(id: "qt-khatam", term: "Khatm du'a", definition: "The supplication traditionally offered when a complete reading is sealed.")
    ]

    static let glossary: [KHTerm] = glossaryA + glossaryB + glossaryC

    private static let badgesA: [KHBadge] = [
        KHBadge(id: "qb-first", title: "First Page", detail: "Log your first page of reading."),
        KHBadge(id: "qb-juz", title: "First Part", detail: "Read your first full juz worth of pages."),
        KHBadge(id: "qb-amma", title: "Juz Amma", detail: "Carry a khatm into the thirtieth part."),
        KHBadge(id: "qb-half", title: "The Halfway Ridge", detail: "Pass page 302 — half the mushaf."),
        KHBadge(id: "qb-khatm", title: "Sealed", detail: "Complete a full khatm."),
        KHBadge(id: "qb-threekhatms", title: "Three Seals", detail: "Complete three khatms."),
        KHBadge(id: "qb-tenday", title: "Ten in a Day", detail: "Read ten pages in a single day."),
        KHBadge(id: "qb-twentyday", title: "A Juz in a Day", detail: "Read twenty pages in a single day."),
        KHBadge(id: "qb-week", title: "Seven Days Running", detail: "Keep a 7-day reading streak.")
    ]

    private static let badgesB: [KHBadge] = [
        KHBadge(id: "qb-month", title: "A Month Unbroken", detail: "Keep a 30-day reading streak."),
        KHBadge(id: "qb-days30", title: "Thirty Sittings", detail: "Read on thirty different days."),
        KHBadge(id: "qb-days100", title: "A Hundred Sittings", detail: "Read on a hundred different days."),
        KHBadge(id: "qb-pages604", title: "Six Hundred Four", detail: "Read 604 pages in all — a mushaf's worth."),
        KHBadge(id: "qb-pages3020", title: "Five Books Deep", detail: "Read 3,020 pages in all."),
        KHBadge(id: "qb-planner", title: "The Planner", detail: "Start a khatm with a finish date."),
        KHBadge(id: "qb-quiz", title: "Sound Knowledge", detail: "Score a perfect quiz round."),
        KHBadge(id: "qb-tenquiz", title: "Steady Student", detail: "Finish ten quiz rounds."),
        KHBadge(id: "qb-guides", title: "Well Read", detail: "Finish every guide in the Learn tab.")
    ]

    static let badges: [KHBadge] = badgesA + badgesB
}
