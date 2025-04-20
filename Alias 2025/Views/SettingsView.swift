import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = GameSettings.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Игра")) {
                    Picker("Язык", selection: $settings.selectedLanguage) {
                        ForEach(GameSettings.Language.allCases) { language in
                            Text(language.rawValue).tag(language)
                        }
                    }
                    
                    Picker("Сложность", selection: $settings.selectedDifficulty) {
                        Text("Легкий").tag(Word.Difficulty.easy)
                        Text("Средний").tag(Word.Difficulty.medium)
                        Text("Сложный").tag(Word.Difficulty.hard)
                    }
                    
                    Stepper(
                        "Время раунда: \(Int(settings.roundDuration))с",
                        value: $settings.roundDuration,
                        in: 30...180,
                        step: 10
                    )
                }
                
                Section(header: Text("Подсчет очков")) {
                    Toggle("Учитывать штрафные баллы", isOn: $settings.countPenaltyPoints)
                    
                    if settings.countPenaltyPoints {
                        Text("За каждое пропущенное слово вычитается 1 балл из общего результата")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Команды")) {
                    NavigationLink("Управление командами") {
                        TeamManagementView()
                    }
                }
            }
            .navigationTitle("Настройки")
            .navigationBarItems(trailing: Button("Готово") {
                dismiss()
            })
        }
    }
}

struct TeamManagementView: View {
    @ObservedObject private var settings = GameSettings.shared
    @State private var showingAddTeam = false
    @State private var newTeamName = ""
    @State private var newExplainer = ""
    @State private var newGuesser = ""
    
    var body: some View {
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
            
            Button(action: {
                showingAddTeam = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Добавить команду")
                }
            }
        }
        .navigationTitle("Команды")
        .sheet(isPresented: $showingAddTeam) {
            NavigationView {
                Form {
                    Section(header: Text("Название команды")) {
                        TextField("Введите название", text: $newTeamName)
                    }
                    
                    Section(header: Text("Игроки")) {
                        TextField("Объясняющий", text: $newExplainer)
                        TextField("Отгадывающий", text: $newGuesser)
                    }
                }
                .navigationTitle("Новая команда")
                .navigationBarItems(
                    leading: Button("Отмена") {
                        showingAddTeam = false
                    },
                    trailing: Button("Добавить") {
                        let team = Game.Team(
                            name: newTeamName,
                            explainer: newExplainer,
                            guesser: newGuesser
                        )
                        settings.teams.append(team)
                        newTeamName = ""
                        newExplainer = ""
                        newGuesser = ""
                        showingAddTeam = false
                    }
                    .disabled(newTeamName.isEmpty || newExplainer.isEmpty || newGuesser.isEmpty)
                )
            }
        }
    }
}

#Preview {
    SettingsView()
} 