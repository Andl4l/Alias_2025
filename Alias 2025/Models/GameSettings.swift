import Foundation

class GameSettings: ObservableObject {
    @Published var selectedLanguage: Language = .russian
    @Published var selectedDifficulty: Word.Difficulty = .medium
    @Published var roundDuration: TimeInterval = 60
    @Published var countPenaltyPoints: Bool = false
    @Published var teams: [Game.Team] = []
    
    enum Language: String, CaseIterable, Identifiable {
        case russian = "Русский"
        case english = "English"
        
        var id: String { self.rawValue }
        
        var fileName: String {
            switch self {
            case .russian: return "words_ru"
            case .english: return "words_en"
            }
        }
    }
    
    static let shared = GameSettings()
    private init() {}
} 