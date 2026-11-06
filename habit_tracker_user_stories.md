# Habit Tracker - User Stories

## US1: Create a New Habit
**Title:**
_As a user, I want to create a new habit, so that I can start tracking it._
**Acceptance Criteria:**
1. User can enter habit name, description, and frequency.
2. User can select category and start date.
3. New habit appears in the habits list after saving.
**Priority:** High
**Story Points:** 5
**Notes:**
- Habit name is required.
- Frequency options: Daily, Weekly, Custom.

## US2: View My Habits List
**Title:**
_As a user, I want to view all my habits in one list, so that I can see what I need to do today._
**Acceptance Criteria:**
1. All habits are displayed with name and status.
2. Today's habits are highlighted.
3. Empty state is shown if no habits exist.
**Priority:** High
**Story Points:** 3
**Notes:**
- List should load quickly and show completion status.

## US3: Mark Habit as Complete
**Title:**
_As a user, I want to mark a habit as complete for today, so that I can track my progress._
**Acceptance Criteria:**
1. User can tap a checkbox / button to mark habit complete.
2. Completed habit shows a checkmark and changes color.
3. User can undo completion on the same day.
**Priority:** High
**Story Points:** 3
**Notes:**
- Completion is saved per day, not permanently.

## US4: Track Streak and Progress
**Title:**
_As a user, I want to see my streak and progress, so that I stay motivated._
**Acceptance Criteria:**
1. Streak counter shows consecutive days completed.
2. Progress bar shows weekly completion percentage.
3. Streak resets if a day is missed.
**Priority:** Medium
**Story Points:** 5
**Notes:**
- Streak should handle weekly habits differently from daily habits.

## US5: Edit a Habit
**Title:**
_As a user, I want to edit an existing habit, so that I can update its details._
**Acceptance Criteria:**
1. User can change name, description, frequency, and category.
2. Changes are saved and reflected in the list.
3. Past completion history is kept after editing.
**Priority:** Medium
**Story Points:** 3
**Notes:**
- Editing should not delete progress.

## US6: Delete a Habit
**Title:**
_As a user, I want to delete a habit I no longer need, so that my list stays clean._
**Acceptance Criteria:**
1. User can delete a habit from details or list.
2. A confirmation dialog appears before deleting.
3. Deleted habit is removed from the list.
**Priority:** Medium
**Story Points:** 2
**Notes:**
- Deletion should be permanent with confirmation.

## US7: Set Reminders
**Title:**
_As a user, I want to set a reminder for a habit, so that I don't forget to do it._
**Acceptance
