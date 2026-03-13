import SwiftUI

struct PracticeView: View {
    @Bindable var viewModel: FieldingSessionViewModel
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header with position and exit
            HStack {
                Text("守备位置：\(viewModel.position.displayName)")
                    .font(.headline)
                Spacer()
                Button("退出") {
                    onExit()
                }
                .foregroundStyle(.red)
            }
            .padding()

            Divider()

            ScrollView {
                VStack(spacing: 24) {
                    // Diamond
                    DiamondView(
                        situation: viewModel.situation,
                        position: viewModel.position
                    )
                    .padding(.top)

                    // Action area
                    switch viewModel.phase {
                    case .answering:
                        ActionButtonsView(
                            actions: viewModel.availableActions
                        ) { action in
                            viewModel.submitAnswer(action)
                        }

                    case .feedback(let result, let answer, let userAction):
                        FeedbackView(
                            result: result,
                            answer: answer,
                            userAction: userAction
                        ) {
                            viewModel.nextSituation()
                        }
                    }

                    // Progress
                    if viewModel.stats.total > 0 {
                        HStack(spacing: 16) {
                            statBadge("总计", "\(viewModel.stats.total)", .secondary)
                            statBadge("最佳", "\(viewModel.stats.bestCount)", .green)
                            statBadge("可接受", "\(viewModel.stats.acceptableCount)", .orange)
                            statBadge("错误", "\(viewModel.stats.wrongCount)", .red)
                        }
                        .font(.caption)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func statBadge(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .foregroundStyle(.secondary)
        }
    }
}
