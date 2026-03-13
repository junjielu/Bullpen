import SwiftUI

struct StatsView: View {
    let stats: SessionStats
    let position: Position
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("练习结束")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("守备位置：\(position.displayName)")
                .font(.title3)
                .foregroundStyle(.secondary)

            // Stats grid
            VStack(spacing: 20) {
                statRow("总题数", "\(stats.total)", .primary)
                statRow("最佳", "\(stats.bestCount)", .green)
                statRow("可接受", "\(stats.acceptableCount)", .orange)
                statRow("错误", "\(stats.wrongCount)", .red)

                Divider()

                statRow("正确率", String(format: "%.0f%%", stats.accuracy), .blue)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            )
            .padding(.horizontal)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Text("返回")
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
            .padding(.bottom)
        }
    }

    @ViewBuilder
    private func statRow(_ label: String, _ value: String, _ color: Color) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
    }
}
