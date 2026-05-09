import Foundation

enum GenerationStyle: String, CaseIterable, Identifiable {
    case ojisan = "おじさん構文"
    case gal = "ギャル語"
    case zGen = "Z世代"
    case showa = "昭和レトロ"
    case chaos = "ごちゃ混ぜ"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .ojisan: return "mustache.fill"
        case .gal: return "sparkles"
        case .zGen: return "iphone.gen3"
        case .showa: return "radio.fill"
        case .chaos: return "shuffle"
        }
    }

    var shortName: String {
        switch self {
        case .ojisan: return "おじ"
        case .gal: return "ギャル"
        case .zGen: return "Z"
        case .showa: return "昭和"
        case .chaos: return "MIX"
        }
    }

    var description: String {
        switch self {
        case .ojisan: return "絵文字多め。距離感が独特なメッセージに変換。"
        case .gal: return "テンション高め。軽くてノリのいい言葉に変換。"
        case .zGen: return "短くラフに。SNSっぽい言い回しへ変換。"
        case .showa: return "少しかためで懐かしい、昔の案内文っぽく変換。"
        case .chaos: return "複数世代の言い方を混ぜて、変な勢いを出します。"
        }
    }

    var sample: String {
        switch self {
        case .ojisan: return "元気かな？今日も頑張ってね😊"
        case .gal: return "それめっちゃ良くない？"
        case .zGen: return "それガチで助かる"
        case .showa: return "まことに結構でございます"
        case .chaos: return "全部の時代を混ぜる"
        }
    }
}

struct TextConverter {
    static func convert(_ text: String, style: GenerationStyle) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        switch style {
        case .ojisan: return toOjisan(trimmed)
        case .gal: return toGal(trimmed)
        case .zGen: return toZGen(trimmed)
        case .showa: return toShowa(trimmed)
        case .chaos: return toChaos(trimmed)
        }
    }

    private static func toOjisan(_ text: String) -> String {
        var parts = splitSentences(text).map { sentence -> String in
            var s = sentence
            s = replaceCommon(s, replacements: [
                ("ありがとう", "ありがとネ"),
                ("お疲れさま", "お疲れ様だヨ"),
                ("元気", "元気カナ"),
                ("すごい", "スゴい"),
                ("かわいい", "カワイイ"),
                ("行く", "行っちゃう"),
                ("です", "だヨ"),
                ("ます", "マス")
            ])
            let marks = ["😊", "😆", "✨", "👍", "‼️", "😉"]
            s += marks.randomElement() ?? "😊"
            if Bool.random() { s += marks.randomElement() ?? "✨" }
            return s
        }
        let openings = ["やっほー😊", "お疲れ様だヨ‼️", "元気カナ？", "ちょっと聞いてネ✨"]
        if Bool.random() {
            parts.insert(openings.randomElement() ?? "やっほー😊", at: 0)
        }
        if Bool.random() {
            parts.append("ところで、ご飯ちゃんと食べたカナ？🍚")
        }
        return parts.joined(separator: " ")
    }

    private static func toGal(_ text: String) -> String {
        let prefixes = ["てか", "まって", "え、", "いやもう"]
        let suffixes = ["じゃん", "すぎ", "って感じ", "かも", "w", "最高"]
        return splitSentences(text).map { sentence in
            var s = replaceCommon(sentence, replacements: [
                ("本当に", "まじで"),
                ("とても", "めっちゃ"),
                ("すごい", "鬼"),
                ("良い", "よすぎ"),
                ("いい", "よすぎ"),
                ("かわいい", "かわいすぎ"),
                ("おいしい", "うますぎ"),
                ("楽しい", "楽しすぎ"),
                ("ありがとう", "ありがと"),
                ("了解", "りょ"),
                ("大丈夫", "だいじょぶ"),
                ("悲しい", "かなしいんだけど"),
                ("無理", "むりみ")
            ])
            if Bool.random() { s = (prefixes.randomElement() ?? "てか") + " " + s }
            s = trimSentenceEnd(s)
            s += " " + (suffixes.randomElement() ?? "じゃん")
            return s
        }.joined(separator: " ")
    }

    private static func toZGen(_ text: String) -> String {
        let suffixes = ["ガチ", "助かる", "それな", "わかる", "強い", "草"]
        return splitSentences(text).map { sentence in
            var s = replaceCommon(sentence, replacements: [
                ("本当に", "ガチで"),
                ("とても", "ガチで"),
                ("すごい", "えぐい"),
                ("良い", "良すぎ"),
                ("いい", "良すぎ"),
                ("面白い", "おもろい"),
                ("つまらない", "おもんな"),
                ("かわいい", "かわいい"),
                ("ありがとう", "あり"),
                ("了解", "りょ"),
                ("大丈夫", "だいじょぶ"),
                ("悲しい", "かなしい"),
                ("無理", "無理")
            ])
            s = trimSentenceEnd(s)
            if Bool.random() { s = "まって " + s }
            s += "、" + (suffixes.randomElement() ?? "それな")
            return s
        }.joined(separator: " ")
    }

    private static func toShowa(_ text: String) -> String {
        return splitSentences(text).map { sentence in
            var s = replaceCommon(sentence, replacements: [
                ("です", "でございます"),
                ("ます", "まする"),
                ("ありがとう", "かたじけない"),
                ("すごい", "恐れ入るほど"),
                ("本当に", "まことに"),
                ("とても", "実に"),
                ("良い", "結構"),
                ("いい", "結構"),
                ("かわいい", "愛らしい"),
                ("かっこいい", "粋な"),
                ("面白い", "愉快"),
                ("つまらない", "味気ない"),
                ("楽しい", "愉快"),
                ("了解", "承知いたした"),
                ("大丈夫", "案ずることなし")
            ])
            s = trimSentenceEnd(s)
            let endings = ["でございます。", "であります。", "なのでございます。", "と申せましょう。"]
            if !s.hasSuffix("ございます") && !s.hasSuffix("まする") {
                s += endings.randomElement() ?? "でございます。"
            } else {
                s += "。"
            }
            return s
        }.joined()
    }

    private static func toChaos(_ text: String) -> String {
        let styles: [GenerationStyle] = [.ojisan, .gal, .zGen, .showa]
        return splitSentences(text).map { sentence in
            let style = styles.randomElement() ?? .zGen
            switch style {
            case .ojisan: return toOjisan(sentence)
            case .gal: return toGal(sentence)
            case .zGen: return toZGen(sentence)
            case .showa: return toShowa(sentence)
            case .chaos: return sentence
            }
        }.joined(separator: " ")
    }

    private static func replaceCommon(_ text: String, replacements: [(String, String)]) -> String {
        var result = text
        for (from, to) in replacements {
            result = result.replacingOccurrences(of: from, with: to)
        }
        return result
    }

    private static func splitSentences(_ text: String) -> [String] {
        var sentences: [String] = []
        var current = ""
        for char in text {
            current.append(char)
            if "。！？!?".contains(char) {
                let trimmed = current.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty { sentences.append(trimmed) }
                current = ""
            }
        }
        let trimmed = current.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { sentences.append(trimmed) }
        return sentences.isEmpty ? [text] : sentences
    }

    private static func trimSentenceEnd(_ text: String) -> String {
        var s = text.trimmingCharacters(in: .whitespacesAndNewlines)
        while let last = s.last, "。！？!?".contains(last) {
            s.removeLast()
        }
        return s
    }
}
