
# Back end must include the following components/modules:
Login Module: Handle user authentication, registration, and login functionality.
basis of this is already in place. This module already exists. Only missing piece separating what an admin can do and what a user can do and have admins only be able to see certain screens (like create_event, user_management, etc).

# User Profile Management Module: Manage user profile data, including location, skills, preferences, and availability.
this is also already mostly in place. Users can currently see and edit their own profile. Need to give admins ability to see all users profiles and disable users from seeing all users' profiles

# Event Management Module: Create and manage events, including required skills, location, urgency, and event details.
this is all pretty much done just need to make sure only admins can do the editing parts

# Volunteer Matching Module: Implement logic to match volunteers to events based on their profiles and event requirements.
need a screen for volunteers that shows events and highlights events they are suited for (based on skillset, preferences, and availability)

# Notification Module: Logic to send notifications to volunteers for event assignments, updates, and reminders.
unsure how to implement this. Maybe email notifications? I'll ask the ta. Any ideas are welcome

# Volunteer History Module: Track and display volunteer participation history.
have volunteers able to see their own history. have admins able to look at history for any volunteer

# Pricing Module: Only create a class. You will implement this in the last assignment.
okay. dunno wtf this is gonna be for


# Important Deliverables
Validations: Ensure validations are in place for required fields, field types, and field lengths in the backend code.
I dont think im doing any validations on the backend. A lot of these could be handled already because flutter widgets are cool, but Im sure some validations still need to be put in place

# Unit Tests: All backend code should be covered by unit tests. Code coverage should be greater than 80%. Research how to - run the code coverage reports. Each IDE has plugins to generate reports. Here are a few pointers: Stackify Code Coverage
erm not sure what this is. Guess I'll have to research it

# Integration with Front End: All front-end components should be connected to the back end. Form data should be populated from the back end. The back end should receive data from the front end, validate it, and prepare it to persist to the database.
already done cause I built a DB for assignment 2 even tho we technically didnt have to until this one

# No Database Implementation: We are not implementing the database yet. For this assignment, you can hard code the values.
lol DB already built oh well



User:
- recommended events (show events best fitted for them)

Admin:
- volunteer-event match (all)
