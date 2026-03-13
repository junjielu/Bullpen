import SwiftUI

struct DiamondView: View {
    let situation: Situation
    let position: Position

    var body: some View {
        VStack(spacing: 16) {
            // Hit type
            Text(situation.hitType.displayName)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.orange.opacity(0.2)))

            // Diamond
            GeometryReader { geo in
                let cx = geo.size.width / 2
                let cy = geo.size.height / 2
                let size = min(geo.size.width, geo.size.height) * 0.35

                ZStack {
                    // Diamond lines
                    DiamondShape()
                        .stroke(Color.secondary.opacity(0.4), lineWidth: 2)
                        .frame(width: size * 2, height: size * 2)
                        .position(x: cx, y: cy)

                    // Second base (top)
                    baseMarker(occupied: situation.runners.contains(.second), label: "2B")
                        .position(x: cx, y: cy - size)

                    // Third base (left)
                    baseMarker(occupied: situation.runners.contains(.third), label: "3B")
                        .position(x: cx - size, y: cy)

                    // First base (right)
                    baseMarker(occupied: situation.runners.contains(.first), label: "1B")
                        .position(x: cx + size, y: cy)

                    // Home plate (bottom)
                    HomePlateShape()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .position(x: cx, y: cy + size)

                    // Position indicator
                    let posOffset = positionOffset(for: position, size: size)
                    Text(position.displayName)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(Circle().fill(Color.blue))
                        .position(x: cx + posOffset.x, y: cy + posOffset.y)
                }
            }
            .frame(height: 200)

            // Outs indicator
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(i < situation.outs ? Color.red : Color.secondary.opacity(0.2))
                        .frame(width: 14, height: 14)
                }
                Text(situation.outsDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Runners text
            Text(situation.runnersDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func positionOffset(for position: Position, size: CGFloat) -> CGPoint {
        switch position {
        case .P:          return CGPoint(x: 0, y: size * 0.15)
        case .C:          return CGPoint(x: 0, y: size * 1.2)
        case .firstBase:  return CGPoint(x: size * 0.85, y: size * 0.15)
        case .secondBase: return CGPoint(x: size * 0.4, y: -size * 0.65)
        case .thirdBase:  return CGPoint(x: -size * 0.85, y: size * 0.15)
        case .SS:         return CGPoint(x: -size * 0.4, y: -size * 0.65)
        case .LF:         return CGPoint(x: -size * 0.85, y: -size * 0.85)
        case .CF:         return CGPoint(x: 0, y: -size * 1.1)
        case .RF:         return CGPoint(x: size * 0.85, y: -size * 0.85)
        }
    }

    @ViewBuilder
    private func baseMarker(occupied: Bool, label: String) -> some View {
        ZStack {
            Rectangle()
                .fill(occupied ? Color.yellow : Color.secondary.opacity(0.15))
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(45))
                .overlay(
                    Rectangle()
                        .stroke(occupied ? Color.orange : Color.secondary.opacity(0.3), lineWidth: 2)
                        .rotationEffect(.degrees(45))
                )
            if occupied {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

struct HomePlateShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.35))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.35))
        path.closeSubpath()
        return path
    }
}
