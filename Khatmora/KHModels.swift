import Foundation

enum KhatmMode: String, Codable {
    case byDate
    case perDay
}

struct KhatmPlan: Codable {
    var startDate: Date = Date()
    var mode: KhatmMode = .perDay
    var targetDate: Date? = nil
    var pagesPerDay: Int = 4
    var position: Int = 0
    var log: [String: Int] = [:]
    var completedOn: Date? = nil

    init() {}

    enum CodingKeys: String, CodingKey {
        case startDate, mode, targetDate, pagesPerDay, position, log, completedOn
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        startDate = (try? c.decodeIfPresent(Date.self, forKey: .startDate)) ?? Date()
        mode = (try? c.decodeIfPresent(KhatmMode.self, forKey: .mode)) ?? .perDay
        targetDate = try? c.decodeIfPresent(Date.self, forKey: .targetDate)
        pagesPerDay = (try? c.decodeIfPresent(Int.self, forKey: .pagesPerDay)) ?? 4
        position = (try? c.decodeIfPresent(Int.self, forKey: .position)) ?? 0
        log = (try? c.decodeIfPresent([String: Int].self, forKey: .log)) ?? [:]
        completedOn = try? c.decodeIfPresent(Date.self, forKey: .completedOn)
    }
}

struct KhatmRecord: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var started: Date = Date()
    var finished: Date = Date()
    var days: Int = 0
}

struct KHGuideSection: Hashable {
    let heading: String
    let body: String
}

struct KHGuide: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let artName: String
    let minutes: Int
    let sections: [KHGuideSection]
    let facts: [String]
}

struct KHTerm: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String
}

struct KHBadge: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
}

enum KHCatalog {
    static let guides: [KHGuide] = KHSpanishContent.guides
    static let glossary: [KHTerm] = KHSpanishContent.glossary
    static let badges: [KHBadge] = KHSpanishContent.badges
}

enum KHSpanishContent {
    private static func guide(_ id: String, _ title: String, _ subtitle: String, _ art: String, _ sections: [(String, String)], _ facts: [String]) -> KHGuide {
        KHGuide(id: id, title: title, subtitle: subtitle, artName: art, minutes: 4,
                sections: sections.map { KHGuideSection(heading: $0.0, body: $0.1) }, facts: facts)
    }

    static let guides: [KHGuide] = [
        guide("qg-mushaf", "Cómo se organiza el Mushaf", "Por qué tiene 604 páginas", "guide-mushaf", [
            ("Una disposición compartida", "La edición de Medina distribuye el Corán en 604 páginas de quince líneas. Millones de ejemplares utilizan esta misma disposición, por lo que una página concreta puede localizarse con facilidad en cualquier lugar."),
            ("La página como medida", "Las suras y las aleyas tienen longitudes muy distintas. La página ofrece una unidad estable para planificar, registrar y comparar el ritmo de lectura."),
            ("Un compañero, no un lector", "La aplicación no reproduce el texto coránico. Acompaña al mushaf que tú elijas y conserva el marcador, el plan y el historial." )
        ], ["Mushaf significa un ejemplar encuadernado del Corán.", "La edición de Medina tiene 604 páginas.", "Cada página contiene normalmente quince líneas."]),
        guide("qg-juz", "Yuz, hizb y rub", "Las treinta partes y sus divisiones", "guide-juz", [
            ("Treinta partes", "El Corán se divide en treinta partes de longitud semejante llamadas yuz. Esta división permite completar la lectura en un mes leyendo una parte cada día."),
            ("Mitades y cuartos", "Cada yuz contiene dos hizb y cada hizb se divide en cuatro cuartos. Estas marcas permiten adaptar la porción al tiempo disponible."),
            ("Yuz Amma", "La parte trigésima reúne las suras breves del final del Corán y suele ser el punto de partida de la memorización.")
        ], ["Un yuz equivale aproximadamente a veinte páginas.", "Un hizb es la mitad de un yuz.", "Yuz Amma es la parte número treinta."]),
        guide("qg-khatm", "Qué es un jatm", "Completar una lectura con intención", "guide-khatm", [
            ("Una lectura completa", "Jatm significa completar el Corán desde Al-Fatihah hasta An-Nas, sin dejar páginas permanentemente sin visitar."),
            ("Un proyecto personal", "Algunas personas completan un jatm al año, otras durante Ramadán o cada mes. La constancia importa más que la velocidad."),
            ("Cuando el ritmo cambia", "Si un día lees menos, el plan recalcula lo que queda sin reproches. Interrumpir y retomar sigue formando parte del mismo camino.")
        ], ["El jatm abarca las 604 páginas.", "Treinta partes encajan de forma natural en un mes.", "Una página diaria completa el libro en menos de dos años."]),
        guide("qg-ramadan", "Ramadán y las treinta partes", "El mes del Corán", "guide-ramadan", [
            ("Un yuz al día", "El ritmo clásico de Ramadán consiste en leer una de las treinta partes cada día para completar el Corán durante el mes."),
            ("Repartir la porción", "Un yuz son unas veinte páginas. Repartidas alrededor de las cinco oraciones, resultan aproximadamente cuatro páginas por momento."),
            ("Un plan flexible", "Elige la fecha prevista del final de Ramadán y la aplicación ajustará diariamente la porción restante.")
        ], ["Veinte páginas diarias completan el Corán en un mes.", "La porción puede dividirse en cinco momentos.", "Empezar antes de Ramadán ayuda a crear el hábito."]),
        guide("qg-pace", "Encontrar tu ritmo", "La aritmética honesta del hábito", "guide-pace", [
            ("Poco y constante", "Dos páginas cada día suelen llegar más lejos que una sesión enorme y ocasional. La mejor porción es la que realmente puedes repetir."),
            ("Unirla a un hábito", "Leer después del fayr, al terminar el trabajo o antes de dormir ofrece un ancla estable para los días ocupados."),
            ("Leer el pronóstico", "La fecha prevista usa tu promedio real, no el ritmo que imaginabas mantener. Así muestra el progreso sin culpa ni falsas promesas.")
        ], ["Dos páginas diarias completan el Corán en unos diez meses.", "Los hábitos anclados duran más.", "El pronóstico utiliza tu ritmo real."]),
        guide("qg-surah", "Sura y aleya", "Las unidades propias del libro", "guide-surah", [
            ("Ciento catorce suras", "El Corán contiene 114 suras de extensión muy diferente. Cada una posee un nombre tradicional y un número fijo."),
            ("Las aleyas", "Cada sura se compone de aleyas. La palabra aleya significa signo, una unidad de recitación y sentido."),
            ("Seguir el recorrido", "El índice de suras muestra dónde comienza cada una y cuál atraviesa actualmente tu marcador.")
        ], ["El Corán contiene 114 suras.", "La cuenta tradicional comprende 6.236 aleyas.", "Al-Fatihah abre el mushaf y An-Nas lo cierra."]),
        guide("qg-makki", "Suras mecanas y medinenses", "Dos etapas de la revelación", "guide-makki", [
            ("Antes y después de la Hégira", "La clasificación depende de si la revelación ocurrió antes o después de la emigración del Profeta a Medina, no simplemente del lugar físico."),
            ("Dos acentos", "Las suras mecanas suelen insistir en la fe, la resurrección y la responsabilidad; las medinenses desarrollan también la vida comunitaria."),
            ("Una ayuda de lectura", "El índice permite filtrar ambas etapas y reconocer el contexto general de cada sura.")
        ], ["La mayoría de las suras son mecanas.", "La Hégira marca la división.", "La clasificación ayuda a situar el contexto."]),
        guide("qg-tilawah", "La cortesía de la lectura", "El adab de la tilawa", "guide-tilawah", [
            ("Llegar con intención", "La tilawa comienza con una intención sincera, un lugar digno y la disposición de escuchar, no solo de avanzar páginas."),
            ("Leer con tartil", "Un ritmo medido permite pronunciar con atención y detenerse cuando el sentido lo pide. La velocidad nunca es el único objetivo."),
            ("Cuidar el mushaf", "Tratar el ejemplar con limpieza y respeto expresa el valor que se concede a la Palabra.")
        ], ["Tilawa significa recitación.", "Tartil es una lectura lenta y medida.", "La intención da forma a la práctica."]),
        guide("qg-memory", "Conservar el hábito", "De la primera página al jatm", "guide-memory", [
            ("Hacer visible el avance", "Un marcador claro convierte una meta enorme en el siguiente paso concreto. Ver crecer el mapa refuerza el regreso diario."),
            ("Volver sin dramatismo", "Una racha puede terminar, pero el libro sigue esperando. Retomar en la siguiente página es más importante que lamentar la pausa."),
            ("Empezar de nuevo", "Al completar un jatm, el registro conserva la fecha y el recorrido. Muchas personas comienzan el siguiente mientras el hábito sigue vivo.")
        ], ["El progreso visible fortalece la constancia.", "Una pausa no borra lo leído.", "Cada jatm terminado queda archivado."])
    ]

    static let glossary: [KHTerm] = [
        KHTerm(id:"qt-mushaf",term:"Mushaf",definition:"Ejemplar físico y encuadernado del Corán."), KHTerm(id:"qt-juz",term:"Yuz",definition:"Una de las treinta partes de longitud semejante del Corán."), KHTerm(id:"qt-hizb",term:"Hizb",definition:"La mitad de un yuz; hay sesenta en todo el libro."), KHTerm(id:"qt-rub",term:"Rub al-hizb",definition:"Un cuarto de hizb, señalado en los márgenes del mushaf."), KHTerm(id:"qt-surah",term:"Sura",definition:"Una de las 114 composiciones con nombre propio del Corán."), KHTerm(id:"qt-ayah",term:"Aleya",definition:"Un versículo; literalmente, un signo."), KHTerm(id:"qt-khatm",term:"Jatm",definition:"Lectura completa del Corán de principio a fin."), KHTerm(id:"qt-tilawah",term:"Tilawa",definition:"El acto de recitar el Corán."), KHTerm(id:"qt-tartil",term:"Tartil",definition:"Recitación lenta, clara y medida."), KHTerm(id:"qt-tajwid",term:"Taywid",definition:"Disciplina de la pronunciación correcta durante la recitación."), KHTerm(id:"qt-juzamma",term:"Yuz Amma",definition:"La parte trigésima, que contiene las suras breves finales."), KHTerm(id:"qt-fatihah",term:"Al-Fatihah",definition:"Sura de apertura, recitada en cada unidad de la oración."), KHTerm(id:"qt-makki",term:"Mecana",definition:"Sura revelada antes de la Hégira a Medina."), KHTerm(id:"qt-madani",term:"Medinense",definition:"Sura revelada después de la Hégira."), KHTerm(id:"qt-hafiz",term:"Hafiz",definition:"Persona que ha memorizado todo el Corán."), KHTerm(id:"qt-hifz",term:"Hifz",definition:"Disciplina de memorizar el Corán."), KHTerm(id:"qt-qari",term:"Qari",definition:"Recitador formado del Corán."), KHTerm(id:"qt-basmalah",term:"Basmalah",definition:"Fórmula que abre todas las suras salvo At-Tawbah."), KHTerm(id:"qt-wird",term:"Wird",definition:"Porción personal fija de lectura o recuerdo diario."), KHTerm(id:"qt-waqf",term:"Waqf",definition:"Punto indicado para detener la recitación."), KHTerm(id:"qt-tarawih",term:"Tarawih",definition:"Oraciones nocturnas de Ramadán."), KHTerm(id:"qt-tafsir",term:"Tafsir",definition:"Comentario y explicación de los significados del Corán."), KHTerm(id:"qt-laylat",term:"Laylat al-Qadr",definition:"La Noche del Decreto, cuando comenzó la revelación."), KHTerm(id:"qt-ajza",term:"Ayza",definition:"Plural de yuz.")
    ]

    static let badges: [KHBadge] = [
        KHBadge(id:"qb-first",title:"Primera página",detail:"Registra tu primera página."), KHBadge(id:"qb-juz",title:"Primera parte",detail:"Lee el equivalente a un yuz."), KHBadge(id:"qb-amma",title:"Yuz Amma",detail:"Llega a la trigésima parte."), KHBadge(id:"qb-half",title:"Mitad del camino",detail:"Supera la página 302."), KHBadge(id:"qb-khatm",title:"Completado",detail:"Termina un jatm completo."), KHBadge(id:"qb-threekhatms",title:"Tres jatms",detail:"Completa tres lecturas."), KHBadge(id:"qb-tenday",title:"Diez en un día",detail:"Lee diez páginas en un día."), KHBadge(id:"qb-twentyday",title:"Un yuz en un día",detail:"Lee veinte páginas en un día."), KHBadge(id:"qb-week",title:"Siete días",detail:"Mantén una racha de siete días."), KHBadge(id:"qb-month",title:"Un mes constante",detail:"Mantén una racha de treinta días."), KHBadge(id:"qb-days30",title:"Treinta sesiones",detail:"Lee en treinta días distintos."), KHBadge(id:"qb-days100",title:"Cien sesiones",detail:"Lee en cien días distintos."), KHBadge(id:"qb-pages604",title:"Seiscientas cuatro",detail:"Lee 604 páginas en total."), KHBadge(id:"qb-pages3020",title:"Cinco mushafs",detail:"Lee 3.020 páginas en total."), KHBadge(id:"qb-planner",title:"Planificador",detail:"Crea un jatm con fecha final."), KHBadge(id:"qb-quiz",title:"Conocimiento sólido",detail:"Consigue una ronda perfecta."), KHBadge(id:"qb-tenquiz",title:"Estudiante constante",detail:"Termina diez cuestionarios."), KHBadge(id:"qb-guides",title:"Buena lectura",detail:"Completa todas las guías.")
    ]
}
