*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser To Login Page
Suite Teardown    Close All Browsers

*** Variables ***
${BASE_URL}     https://opensource-demo.orangehrmlive.com/
${BROWSER}        Chrome

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window

*** Test Cases ***
Login With Valid Credentials
    Go To    ${BASE_URL}
    Input Text    id=Username    Admin
    Input Text    id=Password    admin123
    Click Button    xpath=//button[@type="submit"]
    Page Should Contain    Dashboard

Login With Invalid Credentials
    Go To    ${BASE_URL}
    Input Text    id=Username    wrong_user
    Input Text    id=Password    wrong_pass
    Click Button    xpath=//button[@type="submit"]
    Page Should Contain    Invalid credentials

Login With Empty Credentials
    [Documentation]    Verify error when username and password are empty
    Go To    ${BASE_URL}/login
    Input Text    id=Username
    Input Text    id=Password
    Click Button    id=loginBtn
    Page Should Contain    Username and Password required
Access Restriction For Trainer
    [Documentation]    Trainer cannot access Admin features like Assign
    Go To    ${BASE_URL}/assign-course
    Page Should Contain    Access denied or redirected to trainer dashboard

Unauthorized User Access Blocked
    [Documentation]    Unauthorized users cannot access the system
    Go To    ${BASE_URL}/restricted
    Page Should Contain    Unauthorized user

Trainer Cannot Assign Course
    [Documentation]    Trainer tries to assign course to Test group
    Go To    ${BASE_URL}/courses/assign
    Select From List By Value    id=group    test
    Click Button    id=assignBtn
    Page Should Contain    Access denied

Profile Can Be Edited
    [Documentation]    User can change name/password
    Go To    ${BASE_URL}/profile
    Input Text    id=name    New Name
    Input Text    id=Password    new_password123
    Click Button    id=saveBtn
    Page Should Contain    Profile successfully updated

Invalid Profile Update
    [Documentation]    Invalid profile data should be rejected
    Go To    ${BASE_URL}/profile
    Input Text    id=email    invalid-email-format
    Click Button    id=saveBtn
    Page Should Contain    Error: Invalid profile data

Course Is Created By Admin
    [Documentation]    Admin creates a new course
    Go To    ${BASE_URL}/courses/new
    Input Text    id=title    Test Course
    Input Text    id=description    Sample Description
    Click Button    id=saveBtn
    Page Should Contain    Course saved, visible in course list

Edit Course Details
    [Documentation]    Trainer edits existing course
    Go To    ${BASE_URL}/courses/edit/101
    Input Text    id=title    Updated Title
    Click Button    id=saveBtn
    Page Should Contain    Changes saved successfully

Delete Course
    [Documentation]    Admin removes a course
    Go To    ${BASE_URL}/courses/delete/101
    Page Should Contain    Course removed from list

Assign Course To Employee
    [Documentation]    Admin assigns a course to Employee group
    Go To    ${BASE_URL}/courses/assign
    Select From List By Value    id=group    employee
    Click Button    id=assignBtn
    Page Should Contain    Course assigned to Employee group

Read-Only Course Access For Learners
    [Documentation]    Learners can read but not modify courses
    Go To    ${BASE_URL}/courses/view/101
    Page Should Contain    Course visible but not editable

Duplicate Course Creation Blocked
    [Documentation]    Cannot create a course with duplicate name
    Go To    ${BASE_URL}/courses/new
    Input Text    id=title    Test Course
    Input Text    id=description    Another Description
    Click Button    id=saveBtn
    Page Should Contain    Error: Course name already exists

Invalid Course Creation
    [Documentation]    Missing fields prevent course creation
    Go To    ${BASE_URL}/courses/new
    Input Text    id=title
    Click Button    id=saveBtn
    Page Should Contain    Error: Required fields missing

Validate Course Content Display
    [Documentation]    Course details are visible with chapters, etc.
    Go To    ${BASE_URL}/courses/view/101
    Page Should Contain    Course info displayed correctly

Create New Course Category
    [Documentation]    Add a new course category
    Go To    ${BASE_URL}/categories/new
    Input Text    id=categoryName    Development
    Click Button    id=saveBtn
    Page Should Contain    Category added successfully

Edit Category Name
    [Documentation]    Update existing category
    Go To    ${BASE_URL}/categories/edit/201
    Input Text    id=categoryName    Advanced Development
    Click Button    id=saveBtn
    Page Should Contain    Category updated

Delete Unused Category
    [Documentation]    Remove a category not used by any course
    Go To    ${BASE_URL}/categories/delete/202
    Page Should Contain    Category removed and not shown

Delete Used Category Blocked
    [Documentation]    Category used in courses can't be deleted
    Go To    ${BASE_URL}/categories/delete/201
    Page Should Contain    Error: Category assigned, cannot delete

Duplicate Category Blocked
    [Documentation]    Cannot create a duplicate category
    Go To    ${BASE_URL}/categories/new
    Input Text    id=categoryName    Development
    Click Button    id=saveBtn
    Page Should Contain    Error: Category already exists

Enroll Without Prerequisites
    [Documentation]    User tries enrolling without completing prerequisites
    Go To    ${BASE_URL}/courses/enroll/child
    Page Should Contain    Error or warning message shown

Configure Prerequisite Course
    [Documentation]    Admin sets up prerequisites
    Go To    ${BASE_URL}/courses/prerequisite
    Select From List By Value    id=childCourse    301
    Select From List By Value    id=parentCourse   201
    Click Button    id=saveBtn
    Page Should Contain    Prerequisite saved for course

Block Enrollment If Prereq Missing
    [Documentation]    Learner can't enroll directly in Child course
    Go To    ${BASE_URL}/courses/enroll/301
    Page Should Contain    Can't enroll due to missing prerequisite

Prevent Prerequisite Bypass
    [Documentation]    Learner cannot bypass prerequisite via direct URL
    Go To    ${BASE_URL}/courses/view/301
    Page Should Contain    Error: Cannot bypass prerequisite via direct URL
Mark Attendance Manually
    [Documentation]    Employee manually marks attendance
    Go To    ${BASE_URL}/attendance
    Click Button    id=markAttendance
    Page Should Contain    Attendance marked successfully

View Attendance Report As Manager
    [Documentation]    Manager logs in and opens report
    Go To    ${BASE_URL}/attendance/report
    Page Should Contain    Attendance records displayed accurately

Auto-Mark Attendance On Login
    [Documentation]    Attendance automatically marked when employee logs in
    Go To    ${BASE_URL}/login
    Input Text    id=username    employee_user
    Input Text    id=password    employee_pass
    Click Button    id=loginBtn
    Page Should Contain    Attendance auto-marked

Auto-Mark Attendance With Delay
    [Documentation]    Attendance marked after configured delay
    Go To    ${BASE_URL}/login
    Input Text    id=username    employee_user
    Input Text    id=password    employee_pass
    Click Button    id=loginBtn
    Sleep    5m
    Page Should Contain    Rule triggered: Delay X mins before marking

Prevent Duplicate Attendance
    [Documentation]    Cannot mark attendance twice in a day
    Go To    ${BASE_URL}/attendance
    Click Button    id=markAttendance
    Click Button    id=markAttendance
    Page Should Contain    Error: Already marked for today

Attendance Summary View
    [Documentation]    Summary shown as chart or table
    Go To    ${BASE_URL}/attendance/summary
    Page Should Contain    Summary with present/absent count shown

Attendance Summary Breakdown
    [Documentation]    Summary includes breakdown of present vs absent
    Go To    ${BASE_URL}/attendance/summary
    Page Should Contain    Present/Absent breakdown shown in summary

Invalid Attendance Marking
    [Documentation]    Invalid action should not be accepted
    Go To    ${BASE_URL}/attendance/future
    Click Button    id=markAttendance
    Page Should Contain    Error: Attendance action invalid

Reschedule Live Session
    [Documentation]    Trainer postpones an upcoming class
    Go To    ${BASE_URL}/sessions/reschedule/401
    Input Text    id=newTime    2025-09-05 10:00
    Click Button    id=saveBtn
    Page Should Contain    Session rescheduled

Delete Live Session
    [Documentation]    Trainer or Admin deletes a scheduled session
    Go To    ${BASE_URL}/sessions/delete/401
    Page Should Contain    Session removed

Prevent Double Booking
    [Documentation]    Cannot schedule two sessions at the same time
    Go To    ${BASE_URL}/sessions/new
    Input Text    id=time    2025-09-05 10:00
    Click Button    id=scheduleBtn
    Page Should Contain    Error: Session already booked at this time

Audit Log Records Course Change
    [Documentation]    System logs Admin action in history
    Go To    ${BASE_URL}/audit
    Page Should Contain    Admin action recorded in audit log

Audit Log For Trainer Actions
    [Documentation]    Trainer actions also appear in audit log
    Go To    ${BASE_URL}/audit
    Page Should Contain    Trainer actions logged correctly

Unauthorized Actions Not Logged
    [Documentation]    Unauthorized actions should not appear in logs
    Go To    ${BASE_URL}/audit
    Page Should Contain    Unauthorized action not logged


