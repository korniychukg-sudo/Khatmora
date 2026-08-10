import Foundation

extension SurahData {
    private static let s4: [SurahInfo] = [
        SurahInfo(number: 58, arabic: "المجادلة", translit: "Al-Mujadilah", meaning: "The Pleading Woman", ayahs: 22, medinan: true, startPage: 542),
        SurahInfo(number: 59, arabic: "الحشر", translit: "Al-Hashr", meaning: "The Gathering", ayahs: 24, medinan: true, startPage: 545),
        SurahInfo(number: 60, arabic: "الممتحنة", translit: "Al-Mumtahanah", meaning: "The Woman Examined", ayahs: 13, medinan: true, startPage: 549),
        SurahInfo(number: 61, arabic: "الصف", translit: "As-Saff", meaning: "The Ranks", ayahs: 14, medinan: true, startPage: 551),
        SurahInfo(number: 62, arabic: "الجمعة", translit: "Al-Jumu'ah", meaning: "The Friday Congregation", ayahs: 11, medinan: true, startPage: 553),
        SurahInfo(number: 63, arabic: "المنافقون", translit: "Al-Munafiqun", meaning: "The Hypocrites", ayahs: 11, medinan: true, startPage: 554),
        SurahInfo(number: 64, arabic: "التغابن", translit: "At-Taghabun", meaning: "The Mutual Loss and Gain", ayahs: 18, medinan: true, startPage: 556),
        SurahInfo(number: 65, arabic: "الطلاق", translit: "At-Talaq", meaning: "The Divorce", ayahs: 12, medinan: true, startPage: 558),
        SurahInfo(number: 66, arabic: "التحريم", translit: "At-Tahrim", meaning: "The Prohibition", ayahs: 12, medinan: true, startPage: 560),
        SurahInfo(number: 67, arabic: "الملك", translit: "Al-Mulk", meaning: "The Sovereignty", ayahs: 30, medinan: false, startPage: 562),
        SurahInfo(number: 68, arabic: "القلم", translit: "Al-Qalam", meaning: "The Pen", ayahs: 52, medinan: false, startPage: 564),
        SurahInfo(number: 69, arabic: "الحاقة", translit: "Al-Haqqah", meaning: "The Sure Reality", ayahs: 52, medinan: false, startPage: 566),
        SurahInfo(number: 70, arabic: "المعارج", translit: "Al-Ma'arij", meaning: "The Ways of Ascent", ayahs: 44, medinan: false, startPage: 568),
        SurahInfo(number: 71, arabic: "نوح", translit: "Nuh", meaning: "Noah", ayahs: 28, medinan: false, startPage: 570),
        SurahInfo(number: 72, arabic: "الجن", translit: "Al-Jinn", meaning: "The Jinn", ayahs: 28, medinan: false, startPage: 572),
        SurahInfo(number: 73, arabic: "المزمل", translit: "Al-Muzzammil", meaning: "The Enshrouded One", ayahs: 20, medinan: false, startPage: 574),
        SurahInfo(number: 74, arabic: "المدثر", translit: "Al-Muddaththir", meaning: "The Cloaked One", ayahs: 56, medinan: false, startPage: 575),
        SurahInfo(number: 75, arabic: "القيامة", translit: "Al-Qiyamah", meaning: "The Resurrection", ayahs: 40, medinan: false, startPage: 577),
        SurahInfo(number: 76, arabic: "الإنسان", translit: "Al-Insan", meaning: "The Human", ayahs: 31, medinan: true, startPage: 578),
        SurahInfo(number: 77, arabic: "المرسلات", translit: "Al-Mursalat", meaning: "Those Sent Forth", ayahs: 50, medinan: false, startPage: 580)
    ]

    private static let s5: [SurahInfo] = [
        SurahInfo(number: 78, arabic: "النبأ", translit: "An-Naba", meaning: "The Great News", ayahs: 40, medinan: false, startPage: 582),
        SurahInfo(number: 79, arabic: "النازعات", translit: "An-Nazi'at", meaning: "Those Who Pull Out", ayahs: 46, medinan: false, startPage: 583),
        SurahInfo(number: 80, arabic: "عبس", translit: "Abasa", meaning: "He Frowned", ayahs: 42, medinan: false, startPage: 585),
        SurahInfo(number: 81, arabic: "التكوير", translit: "At-Takwir", meaning: "The Folding Up", ayahs: 29, medinan: false, startPage: 586),
        SurahInfo(number: 82, arabic: "الانفطار", translit: "Al-Infitar", meaning: "The Cleaving", ayahs: 19, medinan: false, startPage: 587),
        SurahInfo(number: 83, arabic: "المطففين", translit: "Al-Mutaffifin", meaning: "Those Who Deal in Fraud", ayahs: 36, medinan: false, startPage: 587),
        SurahInfo(number: 84, arabic: "الانشقاق", translit: "Al-Inshiqaq", meaning: "The Splitting Asunder", ayahs: 25, medinan: false, startPage: 589),
        SurahInfo(number: 85, arabic: "البروج", translit: "Al-Buruj", meaning: "The Constellations", ayahs: 22, medinan: false, startPage: 590),
        SurahInfo(number: 86, arabic: "الطارق", translit: "At-Tariq", meaning: "The Night Visitor", ayahs: 17, medinan: false, startPage: 591),
        SurahInfo(number: 87, arabic: "الأعلى", translit: "Al-A'la", meaning: "The Most High", ayahs: 19, medinan: false, startPage: 591),
        SurahInfo(number: 88, arabic: "الغاشية", translit: "Al-Ghashiyah", meaning: "The Overwhelming", ayahs: 26, medinan: false, startPage: 592),
        SurahInfo(number: 89, arabic: "الفجر", translit: "Al-Fajr", meaning: "The Dawn", ayahs: 30, medinan: false, startPage: 593),
        SurahInfo(number: 90, arabic: "البلد", translit: "Al-Balad", meaning: "The City", ayahs: 20, medinan: false, startPage: 594),
        SurahInfo(number: 91, arabic: "الشمس", translit: "Ash-Shams", meaning: "The Sun", ayahs: 15, medinan: false, startPage: 595),
        SurahInfo(number: 92, arabic: "الليل", translit: "Al-Layl", meaning: "The Night", ayahs: 21, medinan: false, startPage: 595),
        SurahInfo(number: 93, arabic: "الضحى", translit: "Ad-Duha", meaning: "The Morning Brightness", ayahs: 11, medinan: false, startPage: 596),
        SurahInfo(number: 94, arabic: "الشرح", translit: "Ash-Sharh", meaning: "The Expansion", ayahs: 8, medinan: false, startPage: 596),
        SurahInfo(number: 95, arabic: "التين", translit: "At-Tin", meaning: "The Fig", ayahs: 8, medinan: false, startPage: 597),
        SurahInfo(number: 96, arabic: "العلق", translit: "Al-Alaq", meaning: "The Clinging Clot", ayahs: 19, medinan: false, startPage: 597),
        SurahInfo(number: 97, arabic: "القدر", translit: "Al-Qadr", meaning: "The Night of Decree", ayahs: 5, medinan: false, startPage: 598)
    ]

    private static let s6: [SurahInfo] = [
        SurahInfo(number: 98, arabic: "البينة", translit: "Al-Bayyinah", meaning: "The Clear Evidence", ayahs: 8, medinan: true, startPage: 598),
        SurahInfo(number: 99, arabic: "الزلزلة", translit: "Az-Zalzalah", meaning: "The Earthquake", ayahs: 8, medinan: true, startPage: 599),
        SurahInfo(number: 100, arabic: "العاديات", translit: "Al-Adiyat", meaning: "The Chargers", ayahs: 11, medinan: false, startPage: 599),
        SurahInfo(number: 101, arabic: "القارعة", translit: "Al-Qari'ah", meaning: "The Striking Hour", ayahs: 11, medinan: false, startPage: 600),
        SurahInfo(number: 102, arabic: "التكاثر", translit: "At-Takathur", meaning: "The Rivalry in Increase", ayahs: 8, medinan: false, startPage: 600),
        SurahInfo(number: 103, arabic: "العصر", translit: "Al-Asr", meaning: "The Time", ayahs: 3, medinan: false, startPage: 601),
        SurahInfo(number: 104, arabic: "الهمزة", translit: "Al-Humazah", meaning: "The Slanderer", ayahs: 9, medinan: false, startPage: 601),
        SurahInfo(number: 105, arabic: "الفيل", translit: "Al-Fil", meaning: "The Elephant", ayahs: 5, medinan: false, startPage: 601),
        SurahInfo(number: 106, arabic: "قريش", translit: "Quraysh", meaning: "Quraysh", ayahs: 4, medinan: false, startPage: 602),
        SurahInfo(number: 107, arabic: "الماعون", translit: "Al-Ma'un", meaning: "The Small Kindness", ayahs: 7, medinan: false, startPage: 602),
        SurahInfo(number: 108, arabic: "الكوثر", translit: "Al-Kawthar", meaning: "The Abundance", ayahs: 3, medinan: false, startPage: 602),
        SurahInfo(number: 109, arabic: "الكافرون", translit: "Al-Kafirun", meaning: "The Disbelievers", ayahs: 6, medinan: false, startPage: 603),
        SurahInfo(number: 110, arabic: "النصر", translit: "An-Nasr", meaning: "The Help", ayahs: 3, medinan: true, startPage: 603),
        SurahInfo(number: 111, arabic: "المسد", translit: "Al-Masad", meaning: "The Palm Fiber", ayahs: 5, medinan: false, startPage: 603),
        SurahInfo(number: 112, arabic: "الإخلاص", translit: "Al-Ikhlas", meaning: "The Sincerity", ayahs: 4, medinan: false, startPage: 604),
        SurahInfo(number: 113, arabic: "الفلق", translit: "Al-Falaq", meaning: "The Daybreak", ayahs: 5, medinan: false, startPage: 604),
        SurahInfo(number: 114, arabic: "الناس", translit: "An-Nas", meaning: "Mankind", ayahs: 6, medinan: false, startPage: 604)
    ]

    static let part2: [SurahInfo] = s4 + s5 + s6
}
