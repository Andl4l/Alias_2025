import Foundation

class Game: ObservableObject {
    @Published var currentTeam: Team
    @Published var currentRound: Int = 1
    @Published var currentWord: Word?
    @Published var isGameActive = false
    @Published var isPaused = false
    @Published var timeRemaining: TimeInterval
    @Published var guessedWords: [Team: Int] = [:]
    @Published var skippedWords: [Team: Int] = [:]
    @Published var showingResults = false
    @Published var isRoundStarted = false
    @Published var roundHistory: [(word: Word, isGuessed: Bool)] = []
    
    private var words: [Word] = []
    private var currentWordIndex = 0
    private var timer: Timer?
    let settings = GameSettings.shared
    private var currentTeamIndex = 0
    
    struct Team: Hashable {
        let id: UUID
        let name: String
        var explainer: String
        var guesser: String
        
        init(name: String, explainer: String, guesser: String) {
            self.id = UUID()
            self.name = name
            self.explainer = explainer
            self.guesser = guesser
        }
    }
    
    init() {
        self.currentTeam = GameSettings.shared.teams.first ?? Team(name: "", explainer: "", guesser: "")
        self.timeRemaining = GameSettings.shared.roundDuration
        GameSettings.shared.teams.forEach { team in
            guessedWords[team] = 0
            skippedWords[team] = 0
        }
        loadWords()
    }
    
    private func loadWords() {
        words = WordService.shared.getWords(
            language: settings.selectedLanguage,
            difficulty: settings.selectedDifficulty
        )
        words.shuffle()
    }
    
    func startGame() {
        isGameActive = true
        isPaused = false
        startTimer()
        nextWord()
    }
    
    func pauseGame() {
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func resumeGame() {
        isPaused = false
        startTimer()
    }
    
    func endGame() {
        isGameActive = false
        isPaused = false
        timer?.invalidate()
        showingResults = true
    }
    
    private func startTimer() {
        timer?.invalidate() // Invalidate any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, !self.isPaused else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endRound()
            }
        }
    }
    
    func startRound() {
        isRoundStarted = true
        isPaused = false
        roundHistory.removeAll()
        timeRemaining = GameSettings.shared.roundDuration
        startTimer()
        nextWord()
    }
    
    func endRound() {
        isPaused = true
        isRoundStarted = false
        showingResults = true
    }
    
    func updateWordResult(word: Word, isGuessed: Bool, isReview: Bool = false) {
        if let index = roundHistory.firstIndex(where: { $0.word == word }) {
            let wasGuessed = roundHistory[index].isGuessed
            roundHistory[index].isGuessed = isGuessed
            
            if isReview {
                // During review, update both counters
                if wasGuessed && !isGuessed {
                    // Word was guessed but now unmarked
                    guessedWords[currentTeam] = (guessedWords[currentTeam] ?? 0) - 1
                    skippedWords[currentTeam] = (skippedWords[currentTeam] ?? 0) + 1
                } else if !wasGuessed && isGuessed {
                    // Word was not guessed but now marked as guessed
                    guessedWords[currentTeam] = (guessedWords[currentTeam] ?? 0) + 1
                    skippedWords[currentTeam] = (skippedWords[currentTeam] ?? 0) - 1
                }
            } else {
                // During gameplay, only update the relevant counter
                if isGuessed {
                    guessedWords[currentTeam] = (guessedWords[currentTeam] ?? 0) + 1
                } else {
                    skippedWords[currentTeam] = (skippedWords[currentTeam] ?? 0) + 1
                }
            }
            
            // Ensure scores don't go below 0
            if let score = guessedWords[currentTeam], score < 0 {
                guessedWords[currentTeam] = 0
            }
            if let score = skippedWords[currentTeam], score < 0 {
                skippedWords[currentTeam] = 0
            }
        }
    }
    
    func nextWord() {
        guard isRoundStarted else { return }
        
        if let word = words.first {
            currentWord = word
            words.removeFirst()
            roundHistory.append((word: word, isGuessed: false))
        } else {
            // If we're out of words, reload them and try again
            loadWords()
            if let word = words.first {
                currentWord = word
                words.removeFirst()
                roundHistory.append((word: word, isGuessed: false))
            } else {
                endRound()
            }
        }
    }
    
    func wordGuessed() {
        if let word = currentWord {
            updateWordResult(word: word, isGuessed: true, isReview: false)
        }
        nextWord()
    }
    
    func wordSkipped() {
        if let word = currentWord {
            updateWordResult(word: word, isGuessed: false, isReview: false)
        }
        nextWord()
    }
    
    func switchToNextTeam() {
        // Find current team index
        guard let currentIndex = GameSettings.shared.teams.firstIndex(where: { $0.id == currentTeam.id }) else { return }
        
        // Calculate next team index
        let nextIndex = (currentIndex + 1) % GameSettings.shared.teams.count
        
        // If we're back to the first team, increment round
        if nextIndex == 0 {
            currentRound += 1
        }
        
        // Switch to next team
        currentTeam = GameSettings.shared.teams[nextIndex]
        
        // Reset round state
        isRoundStarted = false
        roundHistory = []
    }
    
    // Add new function to calculate total score
    func getTotalScore(for team: Team) -> Int {
        let guessed = guessedWords[team] ?? 0
        let skipped = skippedWords[team] ?? 0
        
        if settings.countPenaltyPoints {
            return max(0, guessed - skipped) // Ensure score doesn't go below 0
        } else {
            return guessed
        }
    }
} 