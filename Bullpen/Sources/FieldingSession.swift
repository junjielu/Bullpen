import Foundation
import SwiftUI

// MARK: - Session Stats

struct SessionStats {
    var total: Int = 0
    var bestCount: Int = 0
    var acceptableCount: Int = 0
    var wrongCount: Int = 0

    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(bestCount + acceptableCount) / Double(total) * 100
    }
}

// MARK: - Session Phase

enum SessionPhase {
    case answering
    case feedback(AnswerResult, Answer, Action)
}

// MARK: - ViewModel

@Observable
class FieldingSessionViewModel {
    let position: Position

    private(set) var situation: Situation
    private(set) var availableActions: [Action] = []
    private(set) var stats = SessionStats()
    var phase: SessionPhase = .answering

    init(position: Position) {
        self.position = position
        self.situation = SituationGenerator.generateSituation(for: position)
        self.availableActions = RuleEngine.availableActions(position: position, situation: situation)
    }

    func submitAnswer(_ action: Action) {
        let answer = RuleEngine.evaluate(position: position, situation: situation)
        let result: AnswerResult

        if answer.best.contains(action) {
            result = .best
            stats.bestCount += 1
        } else if answer.acceptable.contains(action) {
            result = .acceptable
            stats.acceptableCount += 1
        } else {
            result = .wrong
            stats.wrongCount += 1
        }

        stats.total += 1
        phase = .feedback(result, answer, action)
    }

    func nextSituation() {
        situation = SituationGenerator.generateSituation(for: position)
        availableActions = RuleEngine.availableActions(position: position, situation: situation)
        phase = .answering
    }
}
