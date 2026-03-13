import Foundation

// MARK: - Position

enum Position: String, CaseIterable, Identifiable {
    case P, C
    case firstBase = "1B"
    case secondBase = "2B"
    case thirdBase = "3B"
    case SS
    case LF, CF, RF

    var id: String { rawValue }

    var displayName: String { rawValue }

    var isOutfielder: Bool {
        switch self {
        case .LF, .CF, .RF: return true
        default: return false
        }
    }
}

// MARK: - Base

enum Base: Comparable, Hashable {
    case first, second, third, home
}

// MARK: - HitType

enum HitType: String, CaseIterable {
    case groundBall
    case flyBall
    case lineDrive
    case bunt

    var displayName: String {
        switch self {
        case .groundBall: return "地滚球"
        case .flyBall: return "高飞球"
        case .lineDrive: return "平飞球"
        case .bunt: return "短打"
        }
    }
}

// MARK: - Action

enum Action: Hashable {
    case throwTo(Base)
    case throwHome
    case stepOnBase(Base)
    case tagRunner
    case holdBall

    var displayName: String {
        switch self {
        case .throwTo(.first): return "传一垒"
        case .throwTo(.second): return "传二垒"
        case .throwTo(.third): return "传三垒"
        case .throwTo(.home): return "传本垒"
        case .throwHome: return "传本垒"
        case .stepOnBase(.first): return "踩一垒"
        case .stepOnBase(.second): return "踩二垒"
        case .stepOnBase(.third): return "踩三垒"
        case .stepOnBase(.home): return "踩本垒"
        case .tagRunner: return "触杀跑者"
        case .holdBall: return "持球"
        }
    }
}

// MARK: - Situation

struct Situation {
    let outs: Int
    let runners: Set<Base>
    let hitType: HitType

    var runnersDescription: String {
        if runners.isEmpty { return "无人在垒" }
        let names = runners.sorted().map { base in
            switch base {
            case .first: return "一垒"
            case .second: return "二垒"
            case .third: return "三垒"
            case .home: return "本垒"
            }
        }
        return names.joined(separator: "、") + "有人"
    }

    var outsDescription: String {
        "\(outs) 出局"
    }
}

// MARK: - Answer

struct Answer {
    let best: [Action]
    let acceptable: [Action]
    let explanation: String
}

// MARK: - AnswerResult

enum AnswerResult {
    case best
    case acceptable
    case wrong

    var displayName: String {
        switch self {
        case .best: return "最佳"
        case .acceptable: return "可接受"
        case .wrong: return "错误"
        }
    }
}
