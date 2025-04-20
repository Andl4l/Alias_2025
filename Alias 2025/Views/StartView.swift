import SwiftUI

struct StartView: View {
    @StateObject private var settings = GameSettings.shared
    @State private var showingSettings = false
    @State private var showingGame = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Teams list
                List {
                    ForEach(settings.teams, id: \.id) { team in
                        VStack(alignment: .leading) {
                            Text(team.name)
                                .font(.headline)
                            Text("Объясняет: \(team.explainer)")
                                .font(.subheadline)
                            Text("Отгадывает: \(team.guesser)")
                                .font(.subheadline)
                        }
                    }
                    .onDelete { indexSet in
                        settings.teams.remove(atOffsets: indexSet)
                    }
                }
                
                // Settings and Start buttons
                VStack(spacing: 16) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Настройки")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        if settings.teams.count >= 2 {
                            showingGame = true
                        }
                    }) {
                        Text("Начать игру")
                            .font(.title2)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(settings.teams.count >= 2 ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(settings.teams.count < 2)
                }
                .padding()
            }
            .navigationTitle("Alias")
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showingGame) {
                GameView(game: Game())
            }
        }
    }
}

#Preview {
    StartView()
} 