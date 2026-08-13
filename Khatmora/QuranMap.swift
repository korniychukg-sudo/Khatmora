import Foundation

enum QuranMap {
    static let totalPages = 604
    static let totalJuz = 30
    static let totalSurahs = 114
    static let totalAyahs = 6236

    static let juzStartPages: [Int] = [
        1, 22, 42, 62, 82, 102, 121, 142, 162, 182,
        201, 222, 242, 262, 282, 302, 322, 342, 362, 382,
        402, 422, 442, 462, 482, 502, 522, 542, 562, 582
    ]

    static let juzOpenings: [String] = [
        "Alif Lam Mim", "Sayaqul", "Tilkar-Rusul", "Lan Tanalu", "Wal-Muhsanat",
        "La Yuhibbullah", "Wa Idha Sami'u", "Wa Law Annana", "Qalal-Mala'", "Wa'lamu",
        "Ya'tadhiruna", "Wa Ma Min Dabbah", "Wa Ma Ubarri'u", "Rubama", "Subhanal-ladhi",
        "Qala Alam", "Iqtaraba", "Qad Aflaha", "Wa Qalal-ladhina", "Amman Khalaq",
        "Utlu Ma Uhiya", "Wa Man Yaqnut", "Wa Mali", "Faman Azlamu", "Ilayhi Yuraddu",
        "Ha Mim", "Qala Fama Khatbukum", "Qad Sami'Allah", "Tabarakal-ladhi", "'Amma"
    ]

    static func juz(forPage page: Int) -> Int {
        var result = 1
        for (i, start) in juzStartPages.enumerated() {
            if page >= start { result = i + 1 }
        }
        return result
    }

    static func juzRange(_ juz: Int) -> ClosedRange<Int> {
        let start = juzStartPages[juz - 1]
        let end = juz < 30 ? juzStartPages[juz] - 1 : totalPages
        return start...end
    }

    static func juzPageCount(_ juz: Int) -> Int {
        juzRange(juz).count
    }

    static func surah(forPage page: Int) -> SurahInfo {
        var result = QuranCatalog.surahs[0]
        for s in QuranCatalog.surahs {
            if page >= s.startPage { result = s }
        }
        return result
    }

    static func surahRange(_ surah: SurahInfo) -> ClosedRange<Int> {
        let start = surah.startPage
        let end = surah.number < 114 ? QuranCatalog.surahs[surah.number].startPage : totalPages
        return start...max(start, end)
    }
}

struct SurahInfo: Identifiable, Hashable {
    let number: Int
    let arabic: String
    let translit: String
    private let sourceMeaning: String
    let ayahs: Int
    let medinan: Bool
    let startPage: Int
    var id: Int { number }
    var meaning: String { SpanishSurahMeanings.values[number - 1] }

    init(number: Int, arabic: String, translit: String, meaning: String, ayahs: Int, medinan: Bool, startPage: Int) {
        self.number = number; self.arabic = arabic; self.translit = translit; self.sourceMeaning = meaning
        self.ayahs = ayahs; self.medinan = medinan; self.startPage = startPage
    }
}

private enum SpanishSurahMeanings {
    static let values = [
        "La Apertura", "La Vaca", "La Familia de Imrán", "Las Mujeres", "La Mesa Servida", "Los Ganados", "Los Lugares Elevados", "El Botín", "El Arrepentimiento", "Jonás",
        "Hud", "José", "El Trueno", "Abraham", "Al-Hiyr", "Las Abejas", "El Viaje Nocturno", "La Caverna", "María", "Ta-Ha",
        "Los Profetas", "La Peregrinación", "Los Creyentes", "La Luz", "El Criterio", "Los Poetas", "Las Hormigas", "El Relato", "La Araña", "Los Bizantinos",
        "Luqmán", "La Postración", "Los Aliados", "Saba", "El Originador", "Ya-Sin", "Los Alineados", "Sad", "Los Grupos", "El Perdonador",
        "Explicadas Detalladamente", "La Consulta", "Los Adornos de Oro", "El Humo", "La Arrodillada", "Las Dunas", "Muhámmad", "La Victoria", "Las Habitaciones", "Qaf",
        "Los Vientos", "El Monte", "La Estrella", "La Luna", "El Compasivo", "El Acontecimiento", "El Hierro", "La Discusión", "La Reunión", "La Examinada",
        "Las Filas", "El Viernes", "Los Hipócritas", "El Desengaño", "El Divorcio", "La Prohibición", "La Soberanía", "El Cálamo", "La Realidad", "Las Vías de Ascenso",
        "Noé", "Los Genios", "El Envuelto", "El Arropado", "La Resurrección", "El Ser Humano", "Los Enviados", "La Noticia", "Los Que Arrancan", "Frunció el Ceño",
        "El Oscurecimiento", "La Hendidura", "Los Defraudadores", "El Resquebrajamiento", "Las Constelaciones", "El Visitante Nocturno", "El Altísimo", "El Envolvente", "La Aurora", "La Ciudad",
        "El Sol", "La Noche", "La Mañana", "La Apertura del Pecho", "La Higuera", "El Coágulo", "El Decreto", "La Evidencia", "El Terremoto", "Los Corceles",
        "La Calamidad", "La Rivalidad", "El Tiempo", "El Difamador", "El Elefante", "Quraysh", "La Ayuda", "La Abundancia", "Los Incrédulos", "El Auxilio",
        "Las Fibras", "La Sinceridad", "El Alba", "La Humanidad"
    ]
}

enum QuranCatalog {
    static let surahs: [SurahInfo] = SurahData.part1 + SurahData.part2
}
