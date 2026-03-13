# Situation Generator

## Purpose

Generates random baseball fielding situations consisting of outs, runners on base, and hit type, filtered by the selected fielding position.

## Requirements

### Requirement: Position enumeration
The system SHALL define 9 fielding positions: P, C, 1B, 2B, 3B, SS, LF, CF, RF.

#### Scenario: All positions available
- **WHEN** the user begins a fielding practice session
- **THEN** all 9 positions SHALL be available for selection

### Requirement: Hit type enumeration
The system SHALL define 4 hit types: groundBall, flyBall, lineDrive, bunt.

#### Scenario: All hit types defined
- **WHEN** a situation is generated
- **THEN** the hit type SHALL be one of the 4 defined types

### Requirement: Situation composition
A situation SHALL consist of: outs (0, 1, or 2), runners on base (any combination of first, second, third -- including none), and a hit type.

#### Scenario: Valid situation fields
- **WHEN** a situation is generated
- **THEN** outs SHALL be 0, 1, or 2
- **THEN** runners SHALL be a subset of {first, second, third}
- **THEN** hit type SHALL be one of the 4 defined types

### Requirement: Random situation generation
The system SHALL randomly generate situations by independently selecting outs, runners, and hit type.

#### Scenario: Random generation
- **WHEN** a new situation is requested for a given position
- **THEN** the system SHALL produce a random valid situation with hit type filtered by position

### Requirement: Hit type filtering by position
The system SHALL filter available hit types based on the selected fielding position to ensure realistic scenarios.

#### Scenario: Outfielders do not receive bunts
- **WHEN** position is LF, CF, or RF
- **THEN** bunt SHALL NOT be a possible hit type

#### Scenario: Infielders receive all hit types
- **WHEN** position is 1B, 2B, 3B, or SS
- **THEN** all 4 hit types SHALL be possible

#### Scenario: Pitcher and catcher hit type filtering
- **WHEN** position is P or C
- **THEN** groundBall, bunt, and flyBall SHALL be possible hit types
- **THEN** lineDrive SHALL be possible but less common

### Requirement: Base enumeration
The system SHALL define bases as: first, second, third, home.

#### Scenario: Bases used in runner tracking
- **WHEN** runners on base are represented
- **THEN** they SHALL use the base enumeration (first, second, third)
