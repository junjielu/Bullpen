## ADDED Requirements

### Requirement: Position selection
The user SHALL select a fielding position before starting a practice session.

#### Scenario: User selects a position
- **WHEN** the user taps on a position (e.g., SS)
- **THEN** the system SHALL start a practice session for that position

### Requirement: Session loop
A practice session SHALL continuously present situations until the user chooses to exit.

#### Scenario: Next situation after answer
- **WHEN** the user submits an answer and reviews the feedback
- **THEN** the system SHALL present the next randomly generated situation

#### Scenario: Session continues until exit
- **WHEN** the user has not chosen to exit
- **THEN** the system SHALL keep generating new situations

### Requirement: Answer evaluation
The system SHALL evaluate the user's selected action against the rule engine's answer and classify it as best, acceptable, or wrong.

#### Scenario: User selects best action
- **WHEN** the user's action matches one of the best actions
- **THEN** the result SHALL be classified as "best" with positive feedback and explanation

#### Scenario: User selects acceptable action
- **WHEN** the user's action matches one of the acceptable actions
- **THEN** the result SHALL be classified as "acceptable" with feedback indicating the best choice and explanation

#### Scenario: User selects wrong action
- **WHEN** the user's action does not match any best or acceptable action
- **THEN** the result SHALL be classified as "wrong" with the correct answer and explanation

### Requirement: Session statistics
The system SHALL track statistics during a practice session: total situations attempted, best answers count, acceptable answers count, wrong answers count.

#### Scenario: Stats update after each answer
- **WHEN** the user submits an answer
- **THEN** the session statistics SHALL be updated accordingly

### Requirement: Exit with statistics
The user SHALL be able to exit the practice session at any time. Upon exit, the system SHALL display session statistics.

#### Scenario: User exits mid-session
- **WHEN** the user taps the exit button during a session
- **THEN** the system SHALL display a summary with total attempts, best count, acceptable count, wrong count, and accuracy percentage

#### Scenario: User exits after zero attempts
- **WHEN** the user exits before answering any situation
- **THEN** the system SHALL return to the position selection screen without showing statistics
