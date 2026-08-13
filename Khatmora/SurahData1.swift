import Foundation

enum SurahData {
    private static let s1: [SurahInfo] = [
        SurahInfo(number: 1, arabic: "الفاتحة", translit: "Al-Fatihah", meaning: "The Opening", ayahs: 7, medinan: false, startPage: 1),
        SurahInfo(number: 2, arabic: "البقرة", translit: "Al-Baqarah", meaning: "The Cow", ayahs: 286, medinan: true, startPage: 2),
        SurahInfo(number: 3, arabic: "آل عمران", translit: "Aal Imran", meaning: "The Family of Imran", ayahs: 200, medinan: true, startPage: 50),
        SurahInfo(number: 4, arabic: "النساء", translit: "An-Nisa", meaning: "The Women", ayahs: 176, medinan: true, startPage: 77),
        SurahInfo(number: 5, arabic: "المائدة", translit: "Al-Ma'idah", meaning: "The Table Spread", ayahs: 120, medinan: true, startPage: 106),
        SurahInfo(number: 6, arabic: "الأنعام", translit: "Al-An'am", meaning: "The Cattle", ayahs: 165, medinan: false, startPage: 128),
        SurahInfo(number: 7, arabic: "الأعراف", translit: "Al-A'raf", meaning: "The Heights", ayahs: 206, medinan: false, startPage: 151),
        SurahInfo(number: 8, arabic: "الأنفال", translit: "Al-Anfal", meaning: "The Spoils of War", ayahs: 75, medinan: true, startPage: 177),
        SurahInfo(number: 9, arabic: "التوبة", translit: "At-Tawbah", meaning: "The Repentance", ayahs: 129, medinan: true, startPage: 187),
        SurahInfo(number: 10, arabic: "يونس", translit: "Yunus", meaning: "Jonah", ayahs: 109, medinan: false, startPage: 208),
        SurahInfo(number: 11, arabic: "هود", translit: "Hud", meaning: "Hud", ayahs: 123, medinan: false, startPage: 221),
        SurahInfo(number: 12, arabic: "يوسف", translit: "Yusuf", meaning: "Joseph", ayahs: 111, medinan: false, startPage: 235),
        SurahInfo(number: 13, arabic: "الرعد", translit: "Ar-Ra'd", meaning: "The Thunder", ayahs: 43, medinan: true, startPage: 249),
        SurahInfo(number: 14, arabic: "إبراهيم", translit: "Ibrahim", meaning: "Abraham", ayahs: 52, medinan: false, startPage: 255),
        SurahInfo(number: 15, arabic: "الحجر", translit: "Al-Hijr", meaning: "The Rocky Tract", ayahs: 99, medinan: false, startPage: 262),
        SurahInfo(number: 16, arabic: "النحل", translit: "An-Nahl", meaning: "The Bee", ayahs: 128, medinan: false, startPage: 267),
        SurahInfo(number: 17, arabic: "الإسراء", translit: "Al-Isra", meaning: "The Night Journey", ayahs: 111, medinan: false, startPage: 282),
        SurahInfo(number: 18, arabic: "الكهف", translit: "Al-Kahf", meaning: "The Cave", ayahs: 110, medinan: false, startPage: 293),
        SurahInfo(number: 19, arabic: "مريم", translit: "Maryam", meaning: "Mary", ayahs: 98, medinan: false, startPage: 305)
    ]

    private static let s2: [SurahInfo] = [
        SurahInfo(number: 20, arabic: "طه", translit: "Ta-Ha", meaning: "Ta-Ha", ayahs: 135, medinan: false, startPage: 312),
        SurahInfo(number: 21, arabic: "الأنبياء", translit: "Al-Anbiya", meaning: "The Prophets", ayahs: 112, medinan: false, startPage: 322),
        SurahInfo(number: 22, arabic: "الحج", translit: "Al-Hajj", meaning: "The Pilgrimage", ayahs: 78, medinan: true, startPage: 332),
        SurahInfo(number: 23, arabic: "المؤمنون", translit: "Al-Mu'minun", meaning: "The Believers", ayahs: 118, medinan: false, startPage: 342),
        SurahInfo(number: 24, arabic: "النور", translit: "An-Nur", meaning: "The Light", ayahs: 64, medinan: true, startPage: 350),
        SurahInfo(number: 25, arabic: "الفرقان", translit: "Al-Furqan", meaning: "The Criterion", ayahs: 77, medinan: false, startPage: 359),
        SurahInfo(number: 26, arabic: "الشعراء", translit: "Ash-Shu'ara", meaning: "The Poets", ayahs: 227, medinan: false, startPage: 367),
        SurahInfo(number: 27, arabic: "النمل", translit: "An-Naml", meaning: "The Ants", ayahs: 93, medinan: false, startPage: 377),
        SurahInfo(number: 28, arabic: "القصص", translit: "Al-Qasas", meaning: "The Stories", ayahs: 88, medinan: false, startPage: 385),
        SurahInfo(number: 29, arabic: "العنكبوت", translit: "Al-Ankabut", meaning: "The Spider", ayahs: 69, medinan: false, startPage: 396),
        SurahInfo(number: 30, arabic: "الروم", translit: "Ar-Rum", meaning: "The Romans", ayahs: 60, medinan: false, startPage: 404),
        SurahInfo(number: 31, arabic: "لقمان", translit: "Luqman", meaning: "Luqman", ayahs: 34, medinan: false, startPage: 411),
        SurahInfo(number: 32, arabic: "السجدة", translit: "As-Sajdah", meaning: "The Prostration", ayahs: 30, medinan: false, startPage: 415),
        SurahInfo(number: 33, arabic: "الأحزاب", translit: "Al-Ahzab", meaning: "The Confederates", ayahs: 73, medinan: true, startPage: 418),
        SurahInfo(number: 34, arabic: "سبأ", translit: "Saba", meaning: "Sheba", ayahs: 54, medinan: false, startPage: 428),
        SurahInfo(number: 35, arabic: "فاطر", translit: "Fatir", meaning: "The Originator", ayahs: 45, medinan: false, startPage: 434),
        SurahInfo(number: 36, arabic: "يس", translit: "Ya-Sin", meaning: "Ya-Sin", ayahs: 83, medinan: false, startPage: 440),
        SurahInfo(number: 37, arabic: "الصافات", translit: "As-Saffat", meaning: "Those Ranged in Ranks", ayahs: 182, medinan: false, startPage: 446),
        SurahInfo(number: 38, arabic: "ص", translit: "Sad", meaning: "Sad", ayahs: 88, medinan: false, startPage: 453),
        SurahInfo(number: 39, arabic: "الزمر", translit: "Az-Zumar", meaning: "The Groups", ayahs: 75, medinan: false, startPage: 458)
    ]

    private static let s3: [SurahInfo] = [
        SurahInfo(number: 40, arabic: "غافر", translit: "Ghafir", meaning: "The Forgiver", ayahs: 85, medinan: false, startPage: 467),
        SurahInfo(number: 41, arabic: "فصلت", translit: "Fussilat", meaning: "Explained in Detail", ayahs: 54, medinan: false, startPage: 477),
        SurahInfo(number: 42, arabic: "الشورى", translit: "Ash-Shura", meaning: "The Consultation", ayahs: 53, medinan: false, startPage: 483),
        SurahInfo(number: 43, arabic: "الزخرف", translit: "Az-Zukhruf", meaning: "The Gold Ornaments", ayahs: 89, medinan: false, startPage: 489),
        SurahInfo(number: 44, arabic: "الدخان", translit: "Ad-Dukhan", meaning: "The Smoke", ayahs: 59, medinan: false, startPage: 496),
        SurahInfo(number: 45, arabic: "الجاثية", translit: "Al-Jathiyah", meaning: "The Kneeling", ayahs: 37, medinan: false, startPage: 499),
        SurahInfo(number: 46, arabic: "الأحقاف", translit: "Al-Ahqaf", meaning: "The Sand Dunes", ayahs: 35, medinan: false, startPage: 502),
        SurahInfo(number: 47, arabic: "محمد", translit: "Muhammad", meaning: "Muhammad", ayahs: 38, medinan: true, startPage: 507),
        SurahInfo(number: 48, arabic: "الفتح", translit: "Al-Fath", meaning: "The Victory", ayahs: 29, medinan: true, startPage: 511),
        SurahInfo(number: 49, arabic: "الحجرات", translit: "Al-Hujurat", meaning: "The Chambers", ayahs: 18, medinan: true, startPage: 515),
        SurahInfo(number: 50, arabic: "ق", translit: "Qaf", meaning: "Qaf", ayahs: 45, medinan: false, startPage: 518),
        SurahInfo(number: 51, arabic: "الذاريات", translit: "Adh-Dhariyat", meaning: "The Scattering Winds", ayahs: 60, medinan: false, startPage: 520),
        SurahInfo(number: 52, arabic: "الطور", translit: "At-Tur", meaning: "The Mount", ayahs: 49, medinan: false, startPage: 523),
        SurahInfo(number: 53, arabic: "النجم", translit: "An-Najm", meaning: "The Star", ayahs: 62, medinan: false, startPage: 526),
        SurahInfo(number: 54, arabic: "القمر", translit: "Al-Qamar", meaning: "The Moon", ayahs: 55, medinan: false, startPage: 528),
        SurahInfo(number: 55, arabic: "الرحمن", translit: "Ar-Rahman", meaning: "The Most Merciful", ayahs: 78, medinan: true, startPage: 531),
        SurahInfo(number: 56, arabic: "الواقعة", translit: "Al-Waqi'ah", meaning: "The Inevitable Event", ayahs: 96, medinan: false, startPage: 534),
        SurahInfo(number: 57, arabic: "الحديد", translit: "Al-Hadid", meaning: "The Iron", ayahs: 29, medinan: true, startPage: 537)
    ]

    static let part1: [SurahInfo] = s1 + s2 + s3
}
