//
//  NLSummaryService.swift
//  NotesApp
//
//  On-device extractive summarization using Apple's NaturalLanguage framework.
//  Scores each sentence by average word frequency and returns the highest-scoring one.
//

import NaturalLanguage

struct NLSummaryService {

    private static let stopWords: Set<String> = [
        "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for",
        "of", "with", "is", "was", "are", "were", "be", "been", "have", "has",
        "had", "do", "does", "did", "will", "would", "could", "should", "may",
        "might", "it", "its", "this", "that", "these", "those", "i", "my", "me",
        "we", "our", "you", "your", "he", "she", "they", "their", "his", "her",
        "not", "no", "so", "if", "as", "by", "up", "out", "just", "also", "then"
    ]

    static func summarize(content: String) -> String {
        let text = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return "" }

        // Split into sentences
        let sentences = tokenize(text, unit: .sentence)
        guard !sentences.isEmpty else { return String(text.prefix(120)) }
        guard sentences.count > 1 else { return sentences[0] }

        // Count word frequencies across the full text
        var wordFrequency: [String: Int] = [:]
        for word in tokenize(text, unit: .word).map({ $0.lowercased() }) {
            guard word.count > 2, !stopWords.contains(word) else { continue }
            wordFrequency[word, default: 0] += 1
        }

        // Score each sentence by average frequency of its content words
        var bestScore = -1.0
        var bestSentence = sentences[0]

        for sentence in sentences {
            let words = tokenize(sentence, unit: .word).map { $0.lowercased() }
            let contentWords = words.filter { $0.count > 2 && !stopWords.contains($0) }
            guard !contentWords.isEmpty else { continue }

            let score = contentWords.reduce(0.0) { $0 + Double(wordFrequency[$1] ?? 0) }
                / Double(contentWords.count)

            if score > bestScore {
                bestScore = score
                bestSentence = sentence
            }
        }

        return bestSentence
    }

    private static func tokenize(_ text: String, unit: NLTokenUnit) -> [String] {
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text
        var tokens: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let token = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !token.isEmpty { tokens.append(token) }
            return true
        }
        return tokens
    }
}
