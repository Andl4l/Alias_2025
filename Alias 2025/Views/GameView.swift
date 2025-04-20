import SwiftUI

struct GameView: View {
    @ObservedObject var game: Game
    @Environment(\.dismiss) private var dismiss
    @State private var wordPosition: CGSize = .zero
    @State private var isDragging = false
    @State private var showNextWord = true
    @State private var showingMenu = false
    
    var body: some View {
        ZStack {
            // Background layers
            VStack(spacing: 0) {
                // Top orange gradient
                LinearGradient(colors: [Color.orange, Color.orange.opacity(0.8)], 
                             startPoint: .top, 
                             endPoint: .bottom)
                    .frame(height: UIScreen.main.bounds.height * 0.3)
                    .edgesIgnoringSafeArea(.top)
                
                // Middle white section
                Color.white
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                
                // Bottom gray gradient
                LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.4)],
                             startPoint: .top,
                             endPoint: .bottom)
                    .frame(height: UIScreen.main.bounds.height * 0.3)
            }
            
            // Content
            VStack(spacing: 0) {
                // Top navigation
                ZStack {
                    HStack {
                        Button(action: {
                            game.pauseGame()
                            showingMenu = true
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Menu")
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        
                        Spacer()
                    }
                    
                    Text(game.currentTeam.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 50)
                
                // Guessed counter
                VStack(spacing: 4) {
                    Text("\(game.guessedWords[game.currentTeam] ?? 0)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                    Text("GUESSED")
                        .font(.title3)
                        .foregroundColor(.white)
                    if game.settings.countPenaltyPoints {
                        Text("Points: \(game.getTotalScore(for: game.currentTeam)) (\(game.guessedWords[game.currentTeam] ?? 0) - \(game.skippedWords[game.currentTeam] ?? 0))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                // Main word area
                if !game.isRoundStarted {
                    Button(action: {
                        game.startRound()
                    }) {
                        Text("START")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                                    .shadow(radius: 10)
                            )
                    }
                } else if let word = game.currentWord, showNextWord {
                    Text(word.text)
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .offset(wordPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    isDragging = true
                                    wordPosition = gesture.translation
                                }
                                .onEnded { gesture in
                                    isDragging = false
                                    let translation = gesture.translation
                                    
                                    if translation.height < -100 {
                                        withAnimation(.spring()) {
                                            wordPosition = CGSize(width: 0, height: -UIScreen.main.bounds.height)
                                            showNextWord = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                game.wordGuessed()
                                                wordPosition = .zero
                                                showNextWord = true
                                            }
                                        }
                                    } else if translation.height > 100 {
                                        withAnimation(.spring()) {
                                            wordPosition = CGSize(width: 0, height: UIScreen.main.bounds.height)
                                            showNextWord = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                game.wordSkipped()
                                                wordPosition = .zero
                                                showNextWord = true
                                            }
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            wordPosition = .zero
                                        }
                                    }
                                }
                        )
                }
                
                Spacer()
                
                // Skipped counter
                Text("SKIPPED")
                    .foregroundColor(.gray)
                    .font(.title3)
                Text("\(game.skippedWords[game.currentTeam] ?? 0)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.gray)
                
                // Bottom controls
                HStack(spacing: 40) {
                    Button(action: {
                        if game.isPaused {
                            game.resumeGame()
                        } else {
                            game.pauseGame()
                        }
                    }) {
                        Text(game.isPaused ? "CONTINUE" : "STOP")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .background(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                    
                    // Timer
                    Text(timeString(from: game.timeRemaining))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 50)
            }
            
            // Round review overlay
            if game.showingResults {
                Color.orange
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            showingMenu = true
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Menu")
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("POINTS SCORED")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text(game.currentTeam.name)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("+\(game.getTotalScore(for: game.currentTeam))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                            )
                            .padding(.trailing)
                    }
                    .padding(.top, 50)
                    
                    // Words list
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(game.roundHistory, id: \.word.id) { item in
                                HStack {
                                    Text(item.word.text)
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        game.updateWordResult(word: item.word, isGuessed: !item.isGuessed, isReview: true)
                                    }) {
                                        Image(systemName: item.isGuessed ? "hand.thumbsup.fill" : "hand.thumbsup")
                                            .foregroundColor(item.isGuessed ? .orange : .gray)
                                            .font(.system(size: 24))
                                    }
                                }
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                
                                Divider()
                                    .background(Color.gray.opacity(0.2))
                            }
                        }
                    }
                    .background(Color.white)
                    
                    // Next button
                    Button(action: {
                        game.switchToNextTeam()
                        game.showingResults = false
                    }) {
                        Text("Next")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue)
                    }
                }
                .background(
                    VStack(spacing: 0) {
                        Color.orange
                        Color.white
                    }
                )
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showingMenu) {
            GameMenuView(game: game, presentationMode: dismiss)
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct GameMenuView: View {
    @ObservedObject var game: Game
    var presentationMode: DismissAction
    @Environment(\.dismiss) var menuPresentationMode
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            List {
                Button("Продолжить игру") {
                    menuPresentationMode()
                    game.resumeGame()
                }
                
                Button("Начать заново") {
                    menuPresentationMode()
                    game.startGame()
                }
                
                Button("Настройки") {
                    showingSettings = true
                }
                
                Button("Вернуться в главное меню") {
                    menuPresentationMode()
                    presentationMode()
                }
            }
            .navigationTitle("Меню")
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
} 
