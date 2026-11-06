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
**Acceptance Criteria:**
1. User can set time and days for reminder.
2. Notification appears at the set time.
3. User can turn reminder on/off.
**Priority:** High
**Story Points:** 3
**Notes:**
- Reminders use local notifications.

## US8: View Habit Details
**Title:**
_As a user, I want to view the details of a habit, so that I can see its history and progress._
**Acceptance Criteria:**
1. User can tap a habit to open its Detail Screen.
2. Detail Screen shows name, description, streak, and calendar history.
3. User can edit or delete from Detail Screen.
**Priority:** High
**Story Points:** 3
**Notes:**
- Detail Screen is reached from Home Screen.

## US9: Login / Register
**Title:**
_As a new user, I want to create an account and log in, so that my habits are saved to my account._
**Acceptance Criteria:**
1. User can register with email and password.
2. User can log in with existing account.
3. Error message appears for wrong email or password.
4. User stays logged in until logout.
**Priority:** High
**Story Points:** 5
**Notes:**
- Login Screen is the first screen for logged-out users.

## US10: Settings Menu
**Title:**
_As a user, I want to open a Settings Menu, so that I can change app preferences._
**Acceptance Criteria:**
1. User can open Settings Menu from Home Screen.
2. Menu shows options: Profile, Notifications, Theme, About.
3. Tapping an option opens its Settings Screen.
**Priority:** Medium
**Story Points:** 2
**Notes:**
- Settings Menu is accessible from all main screens.

## US11: Change Settings
**Title:**
_As a user, I want to change app settings, so that the app fits my preferences._
**Acceptance Criteria:**
1. User can change theme (Light / Dark).
2. User can turn all notifications on/off.
3. User can change profile name.
4. Settings are saved immediately.
**Priority:** Medium
**Story Points:** 3
**Notes:**
- Settings are saved per user.

## US12: Persistent Data
**Title:**
_As a user, I want my habits and progress to be saved, so that I don't lose them when I close the app._
**Acceptance Criteria:**
1. All habits are saved to local database / cloud.
2. Data is still there after closing and reopening the app.
3. Completion history is not lost.
**Priority:** High
**Story Points:** 5
**Notes:**
- Data must persist across app restarts.

## US13: External API Integration
**Title:**
_As a user, I want to connect my habit tracker to my calendar, so that my habits appear in my schedule._
**Acceptance Criteria:**
1. User can connect Google Calendar from Settings.
2. Habit reminders appear as calendar events.
3. Disconnecting removes calendar sync.
**Priority:** Low
**Story Points:** 8
**Notes:**
- Uses Google Calendar External API.
-
