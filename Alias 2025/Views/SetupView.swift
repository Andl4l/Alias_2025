import SwiftUI

struct SetupView: View {
    @StateObject private var settings = GameSettings.shared
    @State private var team1Name = "Команда 1"
    @State private var team2Name = "Команда 2"
    @State private var team1Explainer = ""
    @State private var team1Guesser = ""
    @State private var team2Explainer = ""
    @State private var team2Guesser = ""
    @State private var isGameStarted = false
    @State private var showingSettings = false
    
    private func setupTeams() {
        settings.teams = [
            Game.Team(name: team1Name, explainer: team1Explainer, guesser: team1Guesser),
            Game.Team(name: team2Name, explainer: team2Explainer, guesser: team2Guesser)
        ]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: {
                        showingSettings = true
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Настройки игры")
                        }
                    }
                }
                
                Section(header: Text("Команда 1")) {
                    TextField("Название команды", text: $team1Name)
                    TextField("Объясняющий игрок", text: $team1Explainer)
                    TextField("Отгадывающий игрок", text: $team1Guesser)
                }
                
                Section(header: Text("Команда 2")) {
                    TextField("Название команды", text: $team2Name)
                    TextField("Объясняющий игрок", text: $team2Explainer)
                    TextField("Отгадывающий игрок", text: $team2Guesser)
                }
                
                Section {
                    Button(action: {
                        setupTeams()
                        isGameStarted = true
                    }) {
                        Text("Начать игру")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    .disabled(team1Explainer.isEmpty || team1Guesser.isEmpty || 
                             team2Explainer.isEmpty || team2Guesser.isEmpty)
                }
            }
            .navigationTitle("Настройка игры")
            .sheet(isPresented: $showingSettings) {
                GameSettingsView(settings: settings)
            }
            .fullScreenCover(isPresented: $isGameStarted) {
                GameView(game: Game())
            }
        }
    }
}

struct GameSettingsView: View {
    @ObservedObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Язык")) {
                    Picker("Язык игры", selection: $settings.selectedLanguage) {
                        ForEach(GameSettings.Language.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                }
                
                Section(header: Text("Сложность")) {
                    Picker("Уровень сложности", selection: $settings.selectedDifficulty) {
                        Text("Легкий").tag(Word.Difficulty.easy)
                        Text("Средний").tag(Word.Difficulty.medium)
                        Text("Сложный").tag(Word.Difficulty.hard)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Время раунда")) {
                    Picker("Длительность раунда", selection: $settings.roundDuration) {
                        Text("30 секунд").tag(TimeInterval(30))
                        Text("60 секунд").tag(TimeInterval(60))
                        Text("90 секунд").tag(TimeInterval(90))
                        Text("120 секунд").tag(TimeInterval(120))
                    }
                }
            }
            .navigationTitle("Настройки")
            .navigationBarItems(trailing: Button("Готово") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    SetupView()
} 