## 1. Data Models

- [x] 1.1 Create `Models.swift` with enums: Position (P/C/1B/2B/3B/SS/LF/CF/RF), HitType (groundBall/flyBall/lineDrive/bunt), Base (first/second/third/home), Action (throwTo/throwHome/stepOnBase/tagRunner/holdBall)
- [x] 1.2 Create `Situation` struct (outs: Int, runners: Set<Base>, hitType: HitType) and `Answer` struct (best: [Action], acceptable: [Action], explanation: String)

## 2. Situation Generator

- [x] 2.1 Implement `validHitTypes(for position: Position) -> [HitType]` filtering function (outfielders no bunt, etc.)
- [x] 2.2 Implement `generateSituation(for position: Position) -> Situation` random generation with hit type filtering

## 3. Rule Engine

- [x] 3.1 Implement `forceBases(runners: Set<Base>) -> [Base]` force play calculation
- [x] 3.2 Implement `canStepOnBase(position: Position, base: Base) -> Bool` position-to-base adjacency check
- [x] 3.3 Implement ground ball / bunt evaluation logic (force play, double play, two-out strategy, runners on third)
- [x] 3.4 Implement fly ball evaluation logic (third out, tag-up from third, tag-up from second, no danger)
- [x] 3.5 Implement line drive evaluation logic (third out, double-off opportunities)
- [x] 3.6 Implement `availableActions(position: Position, situation: Situation) -> [Action]` context-sensitive action list generation
- [x] 3.7 Implement top-level `evaluate(position: Position, situation: Situation) -> Answer` combining all rules

## 4. Session Manager

- [x] 4.1 Create `SessionStats` struct (total/best/acceptable/wrong counts, accuracy computation)
- [x] 4.2 Create `FieldingSessionViewModel` (ObservableObject) managing game state: current situation, answer evaluation, stats tracking, exit flow

## 5. UI — Position Selection

- [x] 5.1 Create `PositionSelectionView` displaying 9 positions as tappable buttons
- [x] 5.2 Wire position selection to start a new FieldingSessionViewModel

## 6. UI — Practice Screen

- [x] 6.1 Create `DiamondView` — baseball diamond shape with runner indicators (filled/empty bases), out count, hit type label, player position marker
- [x] 6.2 Create `ActionButtonsView` — display available actions as Chinese-labeled tappable buttons (传一垒, 踩二垒, 传本垒, 持球, etc.)
- [x] 6.3 Create `FeedbackView` — show result (best/acceptable/wrong) with color-coded indicator, explanation text, best answer when applicable, and "下一题" button
- [x] 6.4 Create `PracticeView` composing DiamondView + ActionButtonsView + FeedbackView + exit button, managing state transitions (answering → feedback → next)

## 7. UI — Statistics & Exit

- [x] 7.1 Create `StatsView` displaying session summary (total, best, acceptable, wrong, accuracy %)
- [x] 7.2 Implement exit flow: exit button → StatsView (if attempts > 0) or back to position selection (if 0 attempts)

## 8. Navigation & Integration

- [x] 8.1 Add fielding practice entry point to ContentView (navigation to PositionSelectionView)
- [x] 8.2 Wire full navigation flow: ContentView → PositionSelectionView → PracticeView → StatsView → back
