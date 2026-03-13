# Fielding UI

## Purpose

Defines the user interface for the fielding practice feature, including position selection, diamond visualization, action buttons, feedback display, and statistics.

## Requirements

### Requirement: Position selection screen
The system SHALL display a position selection screen where the user can choose one of 9 fielding positions.

#### Scenario: Position selection layout
- **WHEN** the user opens the fielding practice feature
- **THEN** the system SHALL display all 9 positions (P, C, 1B, 2B, 3B, SS, LF, CF, RF) as selectable options

### Requirement: Diamond visualization
The system SHALL display the current situation using a baseball diamond graphic showing runner positions, out count, and hit type.

#### Scenario: Diamond shows runners
- **WHEN** a situation has runners on first and third
- **THEN** the diamond SHALL visually indicate occupied bases (e.g., filled/highlighted bases at first and third)

#### Scenario: Diamond shows outs
- **WHEN** a situation has 1 out
- **THEN** the display SHALL show "1 OUT" or equivalent indicator

#### Scenario: Diamond shows hit type
- **WHEN** a situation has a ground ball
- **THEN** the display SHALL show the hit type label (e.g., "地滚球")

#### Scenario: Diamond shows player position
- **WHEN** the user is playing as SS
- **THEN** the display SHALL indicate the user's position on or near the diamond

### Requirement: Action selection
The system SHALL display available actions as tappable buttons for the user to choose from.

#### Scenario: Actions displayed as buttons
- **WHEN** a situation is presented
- **THEN** the system SHALL display context-sensitive action buttons (e.g., "传一垒", "踩二垒", "传本垒")

#### Scenario: Action labels in Chinese
- **WHEN** actions are displayed
- **THEN** action labels SHALL be in Chinese (e.g., "传一垒" for throwTo(first), "踩垒包" for stepOnBase, "持球" for holdBall)

### Requirement: Feedback display
The system SHALL display feedback after the user selects an action, showing the result and explanation.

#### Scenario: Best answer feedback
- **WHEN** the user's answer is classified as best
- **THEN** the system SHALL display a positive indicator and the explanation

#### Scenario: Acceptable answer feedback
- **WHEN** the user's answer is classified as acceptable
- **THEN** the system SHALL display that the answer is acceptable, show the best answer, and the explanation

#### Scenario: Wrong answer feedback
- **WHEN** the user's answer is classified as wrong
- **THEN** the system SHALL display that the answer is incorrect, show the correct answer, and the explanation

### Requirement: Continue to next situation
The system SHALL provide a way to proceed to the next situation after reviewing feedback.

#### Scenario: Next button
- **WHEN** feedback is displayed
- **THEN** the system SHALL show a "下一题" (next) button to proceed

### Requirement: Exit button
The system SHALL display an exit button accessible during the practice session.

#### Scenario: Exit always available
- **WHEN** the user is in a practice session
- **THEN** an exit/back button SHALL be visible and tappable

### Requirement: Statistics display on exit
The system SHALL display session statistics when the user exits a session with at least one attempt.

#### Scenario: Statistics summary
- **WHEN** the user exits after answering situations
- **THEN** the system SHALL display: total attempts, best count, acceptable count, wrong count, accuracy percentage
