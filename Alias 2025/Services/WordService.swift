import Foundation

class WordService {
    static let shared = WordService()
    private var wordsByLanguage: [GameSettings.Language: [Word]] = [:]
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        for language in GameSettings.Language.allCases {
            if let url = Bundle.main.url(forResource: language.fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let words = try JSONDecoder().decode([Word].self, from: data)
                    wordsByLanguage[language] = words
                } catch {
                    print("Error loading words for \(language): \(error)")
                    // Fallback to basic words if loading fails
                    wordsByLanguage[language] = createBasicWords(for: language)
                }
            } else {
                wordsByLanguage[language] = createBasicWords(for: language)
            }
        }
    }
    
    private func createBasicWords(for language: GameSettings.Language) -> [Word] {
        switch language {
        case .russian:
            return [
                // Легкие слова
                Word(text: "Дом", difficulty: .easy),
                Word(text: "Кот", difficulty: .easy),
                Word(text: "Мяч", difficulty: .easy),
                Word(text: "Сон", difficulty: .easy),
                Word(text: "Суп", difficulty: .easy),
                Word(text: "Чай", difficulty: .easy),
                Word(text: "Снег", difficulty: .easy),
                Word(text: "Лес", difficulty: .easy),
                Word(text: "Мир", difficulty: .easy),
                Word(text: "Сад", difficulty: .easy),
                Word(text: "Рука", difficulty: .easy),
                Word(text: "Нога", difficulty: .easy),
                Word(text: "Глаз", difficulty: .easy),
                Word(text: "Нос", difficulty: .easy),
                Word(text: "Рот", difficulty: .easy),
                Word(text: "Стол", difficulty: .easy),
                Word(text: "Стул", difficulty: .easy),
                Word(text: "Окно", difficulty: .easy),
                Word(text: "Дверь", difficulty: .easy),
                Word(text: "Пол", difficulty: .easy),
                
                // Средние слова
                Word(text: "Компьютер", difficulty: .medium),
                Word(text: "Телефон", difficulty: .medium),
                Word(text: "Программа", difficulty: .medium),
                Word(text: "Интернет", difficulty: .medium),
                Word(text: "Машина", difficulty: .medium),
                Word(text: "Самолет", difficulty: .medium),
                Word(text: "Корабль", difficulty: .medium),
                Word(text: "Ракета", difficulty: .medium),
                Word(text: "Планета", difficulty: .medium),
                Word(text: "Звезда", difficulty: .medium),
                Word(text: "Музыка", difficulty: .medium),
                Word(text: "Картина", difficulty: .medium),
                Word(text: "Театр", difficulty: .medium),
                Word(text: "Кино", difficulty: .medium),
                Word(text: "Школа", difficulty: .medium),
                Word(text: "Учитель", difficulty: .medium),
                Word(text: "Врач", difficulty: .medium),
                Word(text: "Инженер", difficulty: .medium),
                Word(text: "Художник", difficulty: .medium),
                Word(text: "Писатель", difficulty: .medium),
                
                // Сложные слова
                Word(text: "Философия", difficulty: .hard),
                Word(text: "Демократия", difficulty: .hard),
                Word(text: "Цивилизация", difficulty: .hard),
                Word(text: "Технология", difficulty: .hard),
                Word(text: "Психология", difficulty: .hard),
                Word(text: "Математика", difficulty: .hard),
                Word(text: "Литература", difficulty: .hard),
                Word(text: "Архитектура", difficulty: .hard),
                Word(text: "Революция", difficulty: .hard),
                Word(text: "Эволюция", difficulty: .hard),
                Word(text: "Вселенная", difficulty: .hard),
                Word(text: "Галактика", difficulty: .hard),
                Word(text: "Атмосфера", difficulty: .hard),
                Word(text: "Экосистема", difficulty: .hard),
                Word(text: "Экономика", difficulty: .hard),
                Word(text: "Политика", difficulty: .hard),
                Word(text: "Искусство", difficulty: .hard),
                Word(text: "Культура", difficulty: .hard),
                Word(text: "Традиция", difficulty: .hard),
                Word(text: "Религия", difficulty: .hard)
            ]
        case .english:
            return [
                // Easy words
                Word(text: "Cat", difficulty: .easy),
                Word(text: "Dog", difficulty: .easy),
                Word(text: "Sun", difficulty: .easy),
                Word(text: "Moon", difficulty: .easy),
                Word(text: "Star", difficulty: .easy),
                Word(text: "Tree", difficulty: .easy),
                Word(text: "Book", difficulty: .easy),
                Word(text: "Door", difficulty: .easy),
                Word(text: "Hand", difficulty: .easy),
                Word(text: "Foot", difficulty: .easy),
                Word(text: "Eye", difficulty: .easy),
                Word(text: "Nose", difficulty: .easy),
                Word(text: "Mouth", difficulty: .easy),
                Word(text: "Chair", difficulty: .easy),
                Word(text: "Table", difficulty: .easy),
                Word(text: "House", difficulty: .easy),
                Word(text: "Bird", difficulty: .easy),
                Word(text: "Fish", difficulty: .easy),
                Word(text: "Food", difficulty: .easy),
                Word(text: "Water", difficulty: .easy),
                
                // Medium words
                Word(text: "Computer", difficulty: .medium),
                Word(text: "Phone", difficulty: .medium),
                Word(text: "Program", difficulty: .medium),
                Word(text: "Internet", difficulty: .medium),
                Word(text: "Machine", difficulty: .medium),
                Word(text: "Airplane", difficulty: .medium),
                Word(text: "Ship", difficulty: .medium),
                Word(text: "Rocket", difficulty: .medium),
                Word(text: "Planet", difficulty: .medium),
                Word(text: "Music", difficulty: .medium),
                Word(text: "Picture", difficulty: .medium),
                Word(text: "Theater", difficulty: .medium),
                Word(text: "Cinema", difficulty: .medium),
                Word(text: "School", difficulty: .medium),
                Word(text: "Teacher", difficulty: .medium),
                Word(text: "Doctor", difficulty: .medium),
                Word(text: "Engineer", difficulty: .medium),
                Word(text: "Artist", difficulty: .medium),
                Word(text: "Writer", difficulty: .medium),
                Word(text: "Science", difficulty: .medium),
                
                // Hard words
                Word(text: "Philosophy", difficulty: .hard),
                Word(text: "Democracy", difficulty: .hard),
                Word(text: "Civilization", difficulty: .hard),
                Word(text: "Technology", difficulty: .hard),
                Word(text: "Psychology", difficulty: .hard),
                Word(text: "Mathematics", difficulty: .hard),
                Word(text: "Literature", difficulty: .hard),
                Word(text: "Architecture", difficulty: .hard),
                Word(text: "Revolution", difficulty: .hard),
                Word(text: "Evolution", difficulty: .hard),
                Word(text: "Universe", difficulty: .hard),
                Word(text: "Galaxy", difficulty: .hard),
                Word(text: "Atmosphere", difficulty: .hard),
                Word(text: "Ecosystem", difficulty: .hard),
                Word(text: "Economics", difficulty: .hard),
                Word(text: "Politics", difficulty: .hard),
                Word(text: "Art", difficulty: .hard),
                Word(text: "Culture", difficulty: .hard),
                Word(text: "Tradition", difficulty: .hard),
                Word(text: "Religion", difficulty: .hard)
            ]
        }
    }
    
    func getWords(language: GameSettings.Language, difficulty: Word.Difficulty) -> [Word] {
        let allWords = wordsByLanguage[language] ?? []
        return allWords.filter { $0.difficulty == difficulty }
    }
    
    func getAllWords(language: GameSettings.Language) -> [Word] {
        return wordsByLanguage[language] ?? []
    }
} 