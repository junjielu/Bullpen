import SwiftUI

struct FeedbackView: View {
    let result: AnswerResult
    let answer: Answer
    let userAction: Action
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Result indicator
            HStack(spacing: 8) {
                Image(systemName: resultIcon)
                    .foregroundStyle(resultColor)
                    .font(.title2)
                Text(result.displayName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(resultColor)
            }
            .padding(.vertical, 8)

            // User's choice
            Text("你的选择：\(userAction.displayName)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Best answer (if not best)
            if result != .best {
                if let bestAction = answer.best.first {
                    Text("最佳选择：\(bestAction.displayName)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
            }

            // Explanation
            Text(answer.explanation)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Next button
            Button {
                onNext()
            } label: {
                Text("下一题")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(resultColor.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(resultColor.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var resultIcon: String {
        switch result {
        case .best: return "checkmark.circle.fill"
        case .acceptable: return "checkmark.circle"
        case .wrong: return "xmark.circle.fill"
        }
    }

    private var resultColor: Color {
        switch result {
        case .best: return .green
        case .acceptable: return .orange
        case .wrong: return .red
        }
    }
}
