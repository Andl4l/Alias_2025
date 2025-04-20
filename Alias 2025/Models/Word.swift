import Foundation

struct Word: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let text: String
    let difficulty: Difficulty
    let category: Category
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        case expert = "expert"
    }
    
    enum Category: String, Codable, CaseIterable {
        case nouns = "nouns"
        case verbs = "verbs"
        case adjectives = "adjectives"
        case common = "common"
        case nature = "nature"
        case technology = "technology"
        case science = "science"
        case culture = "culture"
        case sports = "sports"
        case food = "food"
        case professions = "professions"
        
        var localizedName: [GameSettings.Language: String] {
            switch self {
            case .nouns:
                return [.russian: "Существительные", .english: "Nouns"]
            case .verbs:
                return [.russian: "Глаголы", .english: "Verbs"]
            case .adjectives:
                return [.russian: "Прилагательные", .english: "Adjectives"]
            case .common:
                return [.russian: "Общие слова", .english: "Common Words"]
            case .nature:
                return [.russian: "Природа", .english: "Nature"]
            case .technology:
                return [.russian: "Технологии", .english: "Technology"]
            case .science:
                return [.russian: "Наука", .english: "Science"]
            case .culture:
                return [.russian: "Культура", .english: "Culture"]
            case .sports:
                return [.russian: "Спорт", .english: "Sports"]
            case .food:
                return [.russian: "Еда", .english: "Food"]
            case .professions:
                return [.russian: "Профессии", .english: "Professions"]
            }
        }
    }
    
    init(text: String, difficulty: Difficulty = .medium, category: Category = .common) {
        self.id = UUID()
        self.text = text
        self.difficulty = difficulty
        self.category = category
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 