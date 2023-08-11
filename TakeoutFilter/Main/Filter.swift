//
//  Filter.swift
//  TakeoutFilter
//
//  Created by David Guzman on 29/06/2022.
//

import Foundation

class FilterBase {
    
    let dataAccess: DataAccess? = DataAccess()
    
    static let dateFormatter: ISO8601DateFormatter = ISODateFormatter().obtainFormatter()
    
    let porterStemmer = PorterStemmer()
    
    static let stopWords = ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "you're", "you've", "you'll", "you'd", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "she's", "her", "hers", "herself", "it", "it's", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "that'll", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "don't", "should", "should've", "now", "d", "ll", "m", "o", "re", "ve", "y", "ain", "aren", "aren't", "couldn", "couldn't", "didn", "didn't", "doesn", "doesn't", "hadn", "hadn't", "hasn", "hasn't", "haven", "haven't", "isn", "isn't", "ma", "mightn", "mightn't", "mustn", "mustn't", "needn", "needn't", "shan", "shan't", "shouldn", "shouldn't", "wasn", "wasn't", "weren", "weren't", "won", "won't", "wouldn", "wouldn't", "au", "aux", "avec", "ce", "ces", "dans", "de", "des", "du", "elle", "en", "et", "eux", "il", "ils", "je", "la", "le", "les", "leur", "lui", "ma", "mais", "me", "même", "mes", "moi", "mon", "ne", "nos", "notre", "nous", "on", "ou", "par", "pas", "pour", "qu", "que", "qui", "sa", "se", "ses", "son", "sur", "ta", "te", "tes", "toi", "ton", "tu", "un", "une", "vos", "votre", "vous", "c", "d", "j", "l", "à", "m", "n", "s", "t", "y", "été", "étée", "étées", "étés", "étant", "étante", "étants", "étantes", "suis", "es", "est", "sommes", "êtes", "sont", "serai", "seras", "sera", "serons", "serez", "seront", "serais", "serait", "serions", "seriez", "seraient", "étais", "était", "étions", "étiez", "étaient", "fus", "fut", "fûmes", "fûtes", "furent", "sois", "soit", "soyons", "soyez", "soient", "fusse", "fusses", "fût", "fussions", "fussiez", "fussent", "ayant", "ayante", "ayantes", "ayants", "eu", "eue", "eues", "eus", "ai", "as", "avons", "avez", "ont", "aurai", "auras", "aura", "aurons", "aurez", "auront", "aurais", "aurait", "aurions", "auriez", "auraient", "avais", "avait", "avions", "aviez", "avaient", "eut", "eûmes", "eûtes", "eurent", "aie", "aies", "ait", "ayons", "ayez", "aient", "eusse", "eusses", "eût", "eussions", "eussiez", "eussent", "de", "la", "que", "el", "en", "y", "a", "los", "del", "se", "las", "por", "un", "para", "con", "no", "una", "su", "al", "lo", "como", "más", "pero", "sus", "le", "ya", "o", "este", "sí", "porque", "esta", "entre", "cuando", "muy", "sin", "sobre", "también", "me", "hasta", "hay", "donde", "quien", "desde", "todo", "nos", "durante", "todos", "uno", "les", "ni", "contra", "otros", "ese", "eso", "ante", "ellos", "e", "esto", "mí", "antes", "algunos", "qué", "unos", "yo", "otro", "otras", "otra", "él", "tanto", "esa", "estos", "mucho", "quienes", "nada", "muchos", "cual", "poco", "ella", "estar", "estas", "algunas", "algo", "nosotros", "mi", "mis", "tú", "te", "ti", "tu", "tus", "ellas", "nosotras", "vosotros", "vosotras", "os", "mío", "mía", "míos", "mías", "tuyo", "tuya", "tuyos", "tuyas", "suyo", "suya", "suyos", "suyas", "nuestro", "nuestra", "nuestros", "nuestras", "vuestro", "vuestra", "vuestros", "vuestras", "esos", "esas", "estoy", "estás", "está", "estamos", "estáis", "están", "esté", "estés", "estemos", "estéis", "estén", "estaré", "estarás", "estará", "estaremos", "estaréis", "estarán", "estaría", "estarías", "estaríamos", "estaríais", "estarían", "estaba", "estabas", "estábamos", "estabais", "estaban", "estuve", "estuviste", "estuvo", "estuvimos", "estuvisteis", "estuvieron", "estuviera", "estuvieras", "estuviéramos", "estuvierais", "estuvieran", "estuviese", "estuvieses", "estuviésemos", "estuvieseis", "estuviesen", "estando", "estado", "estada", "estados", "estadas", "estad", "he", "has", "ha", "hemos", "habéis", "han", "haya", "hayas", "hayamos", "hayáis", "hayan", "habré", "habrás", "habrá", "habremos", "habréis", "habrán", "habría", "habrías", "habríamos", "habríais", "habrían", "había", "habías", "habíamos", "habíais", "habían", "hube", "hubiste", "hubo", "hubimos", "hubisteis", "hubieron", "hubiera", "hubieras", "hubiéramos", "hubierais", "hubieran", "hubiese", "hubieses", "hubiésemos", "hubieseis", "hubiesen", "habiendo", "habido", "habida", "habidos", "habidas", "soy", "eres", "es", "somos", "sois", "son", "sea", "seas", "seamos", "seáis", "sean", "seré", "serás", "será", "seremos", "seréis", "serán", "sería", "serías", "seríamos", "seríais", "serían", "era", "eras", "éramos", "erais", "eran", "fui", "fuiste", "fue", "fuimos", "fuisteis", "fueron", "fuera", "fueras", "fuéramos", "fuerais", "fueran", "fuese", "fueses", "fuésemos", "fueseis", "fuesen", "sintiendo", "sentido", "sentida", "sentidos", "sentidas", "siente", "sentid", "tengo", "tienes", "tiene", "tenemos", "tenéis", "tienen", "tenga", "tengas", "tengamos", "tengáis", "tengan", "tendré", "tendrás", "tendrá", "tendremos", "tendréis", "tendrán", "tendría", "tendrías", "tendríamos", "tendríais", "tendrían", "tenía", "tenías", "teníamos", "teníais", "tenían", "tuve", "tuviste", "tuvo", "tuvimos", "tuvisteis", "tuvieron", "tuviera", "tuvieras", "tuviéramos", "tuvierais", "tuvieran", "tuviese", "tuvieses", "tuviésemos", "tuvieseis", "tuviesen", "teniendo", "tenido", "tenida", "tenidos", "tenidas", "tened"]

}

enum FilterResultType: Hashable {
    case success
    case error
}

struct FilterPayback: Identifiable {
    let id: FilterResultType
    let message: String
}

protocol Filter {
    
    func filterQueries(content: String, presentationDate: Date, namesToFilter: String) -> FilterOutput

}

extension Filter {
    
    private func extractWordNGrams(_ query: String) -> [NGram] {
        let words: [String] = query.lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined(separator: " ")
            .components(separatedBy: .whitespacesAndNewlines)
        if words.count == 1 {
            return [NGram(query: words[0], isMono: true)]
        }
        // contains the n in n-gram where n > 1
        let indices = words.indices
        let nsize = indices.map {$0 + 1}
        
        var queryAsNGrams: [NGram] = words.map { NGram(query: $0, isMono: true) }
        for n in nsize {
            for i in 0...words.count-n {
                let ngram = words[i...i+n-1].joined(separator: " ")
                queryAsNGrams.append(NGram(query: ngram, isMono: false))
            }
        }
        return queryAsNGrams
    }
    
    func extractWords(_ query: String) -> [String] {
        return query.lowercased()
            .components(separatedBy: CharacterSet.punctuationCharacters)
            .joined(separator: " ")
            .components(separatedBy: .whitespacesAndNewlines)
    }
    
    func isDateWithinTwoYearsBeforePresentation(queryDate: String, presentationDate: Date) -> Bool {
        let qDate = parseQueryDate(queryDate)
        let twoYearsPresDate = presentationDate.addingTimeInterval(-60 * 60 * 24 * 365 * 2)
        let result = qDate >= twoYearsPresDate && qDate <= presentationDate
        return result
    }
    
    func removeNameTokens(myActivityItem: MyActivity, namesToFilter: String) -> Query {
        let names: [String] = namesToFilter.components(separatedBy: .whitespacesAndNewlines)
        var queryTitle = myActivityItem.title
        for n in names {
            queryTitle = myActivityItem.title.replacingOccurrences(of: n, with: "", options: .caseInsensitive, range: nil)
        }
        queryTitle = queryTitle.replacingOccurrences(of: "Searched for ", with: "")
        let qDate = parseQueryDate(myActivityItem.time)
        return Query(query: queryTitle, date: qDate)
    }
    
    func removeNameTokens(myActivityHtmlItem: MyActivityHtml, namesToFilter: String) -> Query {
        let names: [String] = namesToFilter.components(separatedBy: .whitespacesAndNewlines)
        var queryText = myActivityHtmlItem.query
        for n in names {
            queryText = myActivityHtmlItem.query.replacingOccurrences(of: n, with: "", options: .caseInsensitive, range: nil)
        }
        return Query(query: queryText, date: myActivityHtmlItem.date)
    }
    
    func containsTerm(query: String, stemmer: PorterStemmer, dataAccess: DataAccess) throws -> Bool {
        let result = try extractWords(query)
            .map { stemmer.runStemmer($0) }
            .first { try dataAccess.hasTermStemmed($0) }
        return result != nil
    }
    
    // Function filters out words with less than 4 characters to match the stems in the database
    func containsAllTerms(query: String, stemmer: PorterStemmer, dataAccess: DataAccess) throws -> Bool {
        return try extractWords(query)
            .filter { $0.count > 3 }
            .map { stemmer.runStemmer($0) }
            .allSatisfy { try dataAccess.containsTermStemmed($0) }
    }
    
    // Function filters out words with less than 4 characters to match the stems in the database.
    func runStemmerOnEachWord(query: String, stemmer: PorterStemmer) -> String {
        return query.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.count > 3 }
            .map { stemmer.runStemmer($0) }
            .joined(separator: " ")
    }
    
    func containsPhrase(query: String, stemmer: PorterStemmer, dataAccess: DataAccess) throws -> Bool {
        let result = try extractWordNGrams(query)
            .map { removeStopwords($0.query) }
            .map { runStemmerOnEachWord(query: $0, stemmer: stemmer) }
            .first { try dataAccess.containsTermStemmed($0) }
        return result != nil
    }
    
    func parseQueryDate(_ date: String) -> Date {
        return FilterBase.dateFormatter.date(from: date)!
    }
    
    func removeStopwords(_ query: String) -> String {
        return extractWords(query)
            .filter { !FilterBase.stopWords.contains($0) }
            .joined(separator: " ")
    }

}
