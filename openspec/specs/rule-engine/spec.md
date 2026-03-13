# Rule Engine

## Purpose

Evaluates fielding situations and determines the correct fielding actions based on baseball rules, force play logic, hit type, and fielder position.

## Requirements

### Requirement: Action enumeration
The system SHALL define fielding actions: throwTo(base), throwHome, stepOnBase(base), tagRunner, holdBall.

#### Scenario: All action types available
- **WHEN** the rule engine evaluates a situation
- **THEN** the answer SHALL use actions from the defined action set

### Requirement: Answer structure
The rule engine SHALL produce an Answer containing: best (array of optimal actions), acceptable (array of acceptable but sub-optimal actions), and explanation (string describing the reasoning).

#### Scenario: Answer contains best and explanation
- **WHEN** any situation is evaluated
- **THEN** the answer SHALL contain at least one best action and a non-empty explanation

#### Scenario: Acceptable actions are optional
- **WHEN** a situation has only one correct response
- **THEN** the acceptable array MAY be empty

### Requirement: Force play calculation
The system SHALL calculate force bases from the runner configuration. A runner is forced when all bases behind them (including home) are occupied. The batter is always forced to first base.

#### Scenario: No runners -- force at first only
- **WHEN** no runners are on base
- **THEN** force bases SHALL be [first]

#### Scenario: Runner on first -- force at first and second
- **WHEN** runner is on first base only
- **THEN** force bases SHALL be [first, second]

#### Scenario: Runner on second only -- force at first only
- **WHEN** runner is on second base only (first base empty)
- **THEN** force bases SHALL be [first] (second base runner is NOT forced)

#### Scenario: Runners on first and second -- force at first, second, third
- **WHEN** runners are on first and second
- **THEN** force bases SHALL be [first, second, third]

#### Scenario: Bases loaded -- force at all bases including home
- **WHEN** runners are on first, second, and third
- **THEN** force bases SHALL be [first, second, third, home]

### Requirement: Ground ball rules
For ground balls and bunts, the rule engine SHALL determine the correct throw target based on force play opportunities, out count, and double play potential.

#### Scenario: No runners, ground ball
- **WHEN** outs < 3 and no runners on base and hit type is ground ball
- **THEN** best action SHALL be throwTo(first) or stepOnBase(first) if position is 1B

#### Scenario: Two outs, runner on first, ground ball
- **WHEN** outs = 2 and runner on first and hit type is ground ball
- **THEN** best action SHALL be the nearest force out (either stepOnBase or throwTo the nearest force base)

#### Scenario: Less than two outs, runner on first, ground ball -- double play
- **WHEN** outs < 2 and runner on first and hit type is ground ball
- **THEN** best action SHALL be to initiate at the lead force base (second base) for double play opportunity

#### Scenario: Bases loaded, less than two outs, ground ball -- throw home
- **WHEN** outs < 2 and bases loaded and hit type is ground ball
- **THEN** best action SHALL be throwHome (prevent the run)
- **THEN** acceptable actions SHALL include other force play options

#### Scenario: Runner on third forced, ground ball
- **WHEN** runners include third base and third base runner is forced and outs < 2
- **THEN** throwHome SHALL be the best action to prevent scoring

### Requirement: Fly ball rules
For fly balls, the fielder catches the ball for an out. The rule engine SHALL then determine whether to throw to a base to prevent tag-up advancement.

#### Scenario: Two outs, fly ball -- third out
- **WHEN** outs = 2 and hit type is fly ball
- **THEN** best action SHALL be holdBall (catch = third out, inning over)

#### Scenario: Runner on third, less than two outs, fly ball -- prevent tag up
- **WHEN** runner on third and outs < 2 and hit type is fly ball
- **THEN** best action SHALL be throwHome (prevent sacrifice fly scoring)

#### Scenario: Runner on second only, fly ball
- **WHEN** runner on second (no runner on third) and outs < 2 and hit type is fly ball
- **THEN** best action SHALL be throwTo(third) to prevent tag-up advancement
- **THEN** acceptable actions SHALL include holdBall

#### Scenario: No dangerous runners, fly ball
- **WHEN** no runners on second or third and outs < 2 and hit type is fly ball
- **THEN** best action SHALL be holdBall

### Requirement: Line drive rules
For line drives, the fielder catches the ball for an out. Runners may be off their base and can be doubled off.

#### Scenario: Two outs, line drive -- third out
- **WHEN** outs = 2 and hit type is line drive
- **THEN** best action SHALL be holdBall (catch = third out)

#### Scenario: Runners on base, line drive -- double off opportunity
- **WHEN** runners on base and outs < 2 and hit type is line drive
- **THEN** best action SHALL be throwTo the base of the furthest runner (double off)
- **THEN** acceptable actions SHALL include throwTo other occupied bases and holdBall

#### Scenario: No runners, line drive
- **WHEN** no runners on base and hit type is line drive
- **THEN** best action SHALL be holdBall

### Requirement: Position-aware action generation
The rule engine SHALL consider the fielder's position when determining whether an action is stepOnBase or throwTo.

#### Scenario: 1B fielder with force at first
- **WHEN** position is 1B and the correct play is to get the out at first base
- **THEN** best action SHALL be stepOnBase(first) (not throwTo(first))

#### Scenario: SS fielder with force at second
- **WHEN** position is SS and the correct play is to get the out at second base
- **THEN** best action SHALL be stepOnBase(second) (not throwTo(second))

#### Scenario: 2B fielder with force at second
- **WHEN** position is 2B and the correct play is to get the out at second base
- **THEN** best action SHALL be stepOnBase(second) (not throwTo(second))

#### Scenario: 3B fielder with force at third
- **WHEN** position is 3B and the correct play is to get the out at third base
- **THEN** best action SHALL be stepOnBase(third) (not throwTo(third))

### Requirement: Available actions generation
The rule engine SHALL generate context-sensitive available actions for the user to choose from, based on position and situation.

#### Scenario: Outfielder actions exclude step on base
- **WHEN** position is LF, CF, or RF
- **THEN** available actions SHALL NOT include stepOnBase

#### Scenario: Actions include relevant throw targets
- **WHEN** a situation is presented
- **THEN** available actions SHALL include throwTo for relevant bases, throwHome, and holdBall
- **THEN** available actions SHALL include stepOnBase only if the position is adjacent to a force base
