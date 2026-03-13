import Foundation

enum SituationGenerator {

    static func validHitTypes(for position: Position) -> [HitType] {
        switch position {
        case .LF, .CF, .RF:
            return [.groundBall, .flyBall, .lineDrive]
        case .P, .C:
            return [.groundBall, .flyBall, .lineDrive, .bunt]
        case .firstBase, .secondBase, .thirdBase, .SS:
            return [.groundBall, .flyBall, .lineDrive, .bunt]
        }
    }

    static func generateSituation(for position: Position) -> Situation {
        let outs = Int.random(in: 0...2)

        let allRunnerCombinations: [Set<Base>] = [
            [],
            [.first],
            [.second],
            [.third],
            [.first, .second],
            [.first, .third],
            [.second, .third],
            [.first, .second, .third],
        ]
        let runners = allRunnerCombinations.randomElement()!

        let hitTypes = validHitTypes(for: position)
        let hitType = hitTypes.randomElement()!

        return Situation(outs: outs, runners: runners, hitType: hitType)
    }
}
