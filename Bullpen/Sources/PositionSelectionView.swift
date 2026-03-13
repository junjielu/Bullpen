import SwiftUI

struct PositionSelectionView: View {
    let onSelect: (Position) -> Void

    private let fieldLayout: [(Position, CGFloat, CGFloat)] = [
        (.LF, 0.2, 0.15),
        (.CF, 0.5, 0.08),
        (.RF, 0.8, 0.15),
        (.SS, 0.35, 0.38),
        (.secondBase, 0.65, 0.38),
        (.thirdBase, 0.2, 0.5),
        (.firstBase, 0.8, 0.5),
        (.P, 0.5, 0.55),
        (.C, 0.5, 0.75),
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("选择守备位置")
                .font(.title2)
                .fontWeight(.bold)

            GeometryReader { geo in
                ZStack {
                    // Field background
                    DiamondShape()
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        .fill(Color.green.opacity(0.05))
                        .padding(40)

                    ForEach(fieldLayout, id: \.0) { position, x, y in
                        Button {
                            onSelect(position)
                        } label: {
                            Text(position.displayName)
                                .font(.system(.body, design: .monospaced))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(Color.blue))
                        }
                        .position(
                            x: geo.size.width * x,
                            y: geo.size.height * y
                        )
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .padding()
    }
}

// Reusable diamond shape
struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cx = rect.midX
        let cy = rect.midY
        let size = min(rect.width, rect.height) * 0.35
        path.move(to: CGPoint(x: cx, y: cy - size))      // top (2B)
        path.addLine(to: CGPoint(x: cx + size, y: cy))    // right (1B)
        path.addLine(to: CGPoint(x: cx, y: cy + size))    // bottom (home)
        path.addLine(to: CGPoint(x: cx - size, y: cy))    // left (3B)
        path.closeSubpath()
        return path
    }
}

#Preview {
    PositionSelectionView { position in
        print("Selected: \(position.displayName)")
    }
}
