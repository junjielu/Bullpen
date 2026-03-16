import SwiftUI

enum AppScreen {
    case home
    case positionSelection
    case practice(Position)
    case stats(SessionStats, Position)
}

struct ContentView: View {
    @State private var screen: AppScreen = .home
    @State private var viewModel: FieldingSessionViewModel?

    var body: some View {
        switch screen {
        case .home:
            VStack(spacing: 24) {
                Text("Bullpen")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Button {
                    screen = .positionSelection
                } label: {
                    Label("守备练场", systemImage: "sportscourt")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 40)
            }

        case .positionSelection:
            PositionSelectionView { position in
                viewModel = FieldingSessionViewModel(position: position)
                screen = .practice(position)
            }

        case .practice(let position):
            if let viewModel {
                PracticeView(viewModel: viewModel) {
                    if viewModel.stats.total > 0 {
                        screen = .stats(viewModel.stats, position)
                    } else {
                        screen = .positionSelection
                    }
                    self.viewModel = nil
                }
            }

        case .stats(let stats, let position):
            StatsView(stats: stats, position: position) {
                screen = .positionSelection
            }
        }
    }
}

#Preview {
    ContentView()
}
