import Foundation

enum RuleEngine {

    // MARK: - 3.1 Force Play Calculation

    static func forceBases(runners: Set<Base>) -> [Base] {
        var forces: [Base] = [.first]
        if runners.contains(.first) {
            forces.append(.second)
            if runners.contains(.second) {
                forces.append(.third)
                if runners.contains(.third) {
                    forces.append(.home)
                }
            }
        }
        return forces
    }

    // MARK: - 3.2 Position-to-Base Adjacency

    static func canStepOnBase(position: Position, base: Base) -> Bool {
        switch (position, base) {
        case (.firstBase, .first): return true
        case (.secondBase, .second): return true
        case (.SS, .second): return true
        case (.thirdBase, .third): return true
        default: return false
        }
    }

    // MARK: - 3.6 Available Actions

    static func availableActions(position: Position, situation: Situation) -> [Action] {
        var actions: [Action] = []
        let forces = forceBases(runners: situation.runners)

        switch situation.hitType {
        case .groundBall, .bunt:
            // Throw to any base
            for base in [Base.first, .second, .third] {
                if canStepOnBase(position: position, base: base) && forces.contains(base) {
                    actions.append(.stepOnBase(base))
                } else {
                    actions.append(.throwTo(base))
                }
            }
            actions.append(.throwHome)
            if !situation.runners.isEmpty {
                actions.append(.tagRunner)
            }
            actions.append(.holdBall)

        case .flyBall, .lineDrive:
            // After catching, decide where to throw
            for base in [Base.first, .second, .third] {
                actions.append(.throwTo(base))
            }
            actions.append(.throwHome)
            actions.append(.holdBall)
        }

        return actions
    }

    // MARK: - 3.7 Top-level Evaluate

    static func evaluate(position: Position, situation: Situation) -> Answer {
        switch situation.hitType {
        case .groundBall, .bunt:
            return evaluateGroundBall(position: position, situation: situation)
        case .flyBall:
            return evaluateFlyBall(position: position, situation: situation)
        case .lineDrive:
            return evaluateLineDrive(position: position, situation: situation)
        }
    }

    // MARK: - 3.3 Ground Ball / Bunt Evaluation

    private static func evaluateGroundBall(position: Position, situation: Situation) -> Answer {
        let forces = forceBases(runners: situation.runners)

        // No runners — throw/step on first
        if situation.runners.isEmpty {
            let action = makeAction(position: position, targetBase: .first)
            return Answer(
                best: [action],
                acceptable: [],
                explanation: "无人在垒，将打者在一垒封杀出局。"
            )
        }

        // Two outs — get the nearest/easiest out
        if situation.outs == 2 {
            let nearestForce = nearestForceBase(position: position, forces: forces)
            let action = makeAction(position: position, targetBase: nearestForce)
            var acceptable: [Action] = []
            // Other force bases are also acceptable
            for base in forces where base != nearestForce {
                acceptable.append(makeAction(position: position, targetBase: base))
            }
            return Answer(
                best: [action],
                acceptable: acceptable,
                explanation: "二出局，拿最近的封杀出局即可结束这一局。"
            )
        }

        // Less than 2 outs, runners on base

        // Runner on third is forced → throw home to prevent scoring
        if situation.runners.contains(.third) && forces.contains(.home) {
            var acceptable: [Action] = []
            for base in forces where base != .home {
                acceptable.append(makeAction(position: position, targetBase: base))
            }
            return Answer(
                best: [.throwHome],
                acceptable: acceptable,
                explanation: "三垒跑者被迫前进，传本垒阻止得分是最优先选择。"
            )
        }

        // Double play opportunity (multiple force bases, < 2 outs)
        if forces.count >= 2 && situation.outs < 2 {
            // Lead force base (furthest from home, excluding home) for double play start
            let leadForce = forces.filter { $0 != .home && $0 != .first }.max() ?? .second
            let action = makeAction(position: position, targetBase: leadForce)
            var acceptable: [Action] = []
            for base in forces where base != leadForce {
                acceptable.append(makeAction(position: position, targetBase: base))
            }
            return Answer(
                best: [action],
                acceptable: acceptable,
                explanation: "有双杀机会，先在前位垒包取得封杀，再转传一垒完成双杀。"
            )
        }

        // Single force — get the out
        let targetForce = forces.max() ?? .first
        let action = makeAction(position: position, targetBase: targetForce)
        var acceptable: [Action] = []
        if targetForce != .first {
            acceptable.append(makeAction(position: position, targetBase: .first))
        }
        return Answer(
            best: [action],
            acceptable: acceptable,
            explanation: "将跑者在封杀垒包出局。"
        )
    }

    // MARK: - 3.4 Fly Ball Evaluation

    private static func evaluateFlyBall(position: Position, situation: Situation) -> Answer {
        // Catch = third out → inning over
        if situation.outs == 2 {
            return Answer(
                best: [.holdBall],
                acceptable: [],
                explanation: "接杀后即为三出局，半局结束。"
            )
        }

        // Runner on third — prevent tag-up scoring
        if situation.runners.contains(.third) {
            var acceptable: [Action] = []
            if situation.runners.contains(.second) {
                acceptable.append(.throwTo(.third))
            }
            return Answer(
                best: [.throwHome],
                acceptable: acceptable,
                explanation: "接杀后三垒跑者可能 tag up 回本垒得分，传本垒阻止得分。"
            )
        }

        // Runner on second — prevent tag-up to third
        if situation.runners.contains(.second) {
            return Answer(
                best: [.throwTo(.third)],
                acceptable: [.holdBall],
                explanation: "接杀后二垒跑者可能 tag up 推进到三垒，传三垒阻止推进。"
            )
        }

        // No dangerous runners
        return Answer(
            best: [.holdBall],
            acceptable: [],
            explanation: "接杀，无需额外处理，将球回传内野。"
        )
    }

    // MARK: - 3.5 Line Drive Evaluation

    private static func evaluateLineDrive(position: Position, situation: Situation) -> Answer {
        // Catch = third out → inning over
        if situation.outs == 2 {
            return Answer(
                best: [.holdBall],
                acceptable: [],
                explanation: "接杀后即为三出局，半局结束。"
            )
        }

        // No runners — just hold
        if situation.runners.isEmpty {
            return Answer(
                best: [.holdBall],
                acceptable: [],
                explanation: "接杀，无人在垒，无需额外处理。"
            )
        }

        // Runners on base — double off opportunity (runners may be off their base)
        let furthestRunner = situation.runners.max()!
        let targetBase: Base = furthestRunner
        var acceptable: [Action] = []
        for base in situation.runners where base != furthestRunner {
            acceptable.append(.throwTo(base))
        }
        acceptable.append(.holdBall)

        let baseName: String
        switch targetBase {
        case .first: baseName = "一垒"
        case .second: baseName = "二垒"
        case .third: baseName = "三垒"
        case .home: baseName = "本垒"
        }

        return Answer(
            best: [.throwTo(targetBase)],
            acceptable: acceptable,
            explanation: "接杀后跑者可能离垒，传\(baseName)尝试双杀（double off）。"
        )
    }

    // MARK: - Helpers

    private static func makeAction(position: Position, targetBase: Base) -> Action {
        if targetBase == .home {
            return .throwHome
        }
        if canStepOnBase(position: position, base: targetBase) {
            return .stepOnBase(targetBase)
        }
        return .throwTo(targetBase)
    }

    private static func nearestForceBase(position: Position, forces: [Base]) -> Base {
        // Prefer a base the fielder can step on
        for base in forces {
            if canStepOnBase(position: position, base: base) {
                return base
            }
        }
        // Otherwise return first base as the default nearest target
        return .first
    }
}
