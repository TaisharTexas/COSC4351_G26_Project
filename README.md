# COSC4351_G26_Project
Group 26's project


## Assignment 1 thoughts

1) Initial Thoughts:
  - Basic website interface front end UI with Flutter and backend database with Firebase
1a) User Experience:
  - Volunteers will have a sign up/login page. Once in, volunteers will be able to see/edit their own personal info, see current activities, indicate interest in current activities, accept/decline participation in activities. Be able to see past history
  - Admins will have a login page. Once in admins will be able to see all volunteers (and their info including past activities) and all pending activities. Admins will be able to request specific volunteers for specific activities (volunteer will need to confirm participation). Admins can create/modify/remove activities.
1b) Key Functionalities:
  - Need VOLUNTEER view and ADMIN view for front end (think similar to student and teacher view in canvas).
  - Need login/account creation page for volunteers. Need login page for admins (admins can give admin to other volunteers but volunteers cannot just create/register an admin account)
  - Needs a database to store this all in (prob SQL..I have a project from last semester that uses this structure I can show if ppl wanna see a similar implementation)
    - Need to create ERD for database.
1c) Tech Stack:
  - Build UI with [Flutter](https://docs.flutter.dev/get-started/install?_gl=1*fv6ouu*_ga*OTAwMzkwNDk1LjE3MjU2NjUzODU.*_ga_04YGWK0175*MTcyNTY2NTM4NS4xLjAuMTcyNTY2NTM4NS4wLjAuMA..) 
  - Possibly integrate [Firebase](https://firebase.google.com/docs/flutter/setup?platform=ios) into the Flutter app framework for data handling and database needs
  - Use github for version control


2) Dev Methodology:
  - I think waterfall is fine. Maybe in the real world Agile would be better so that the project could adapt to customer needs changing over time and also so the customer can see progress faster. But in this case the project is static because its a graded assignment, so we would be able to do the in depth requirements planning and count on them staying the same for the whole project (which waterfall needs).
  - Waterfall also makes division of labor easier and more concrete whereas Agile requires a lot more active involvement and a higher degree of management/coordination that is challenging in a student body environment.

  3) High-Level Design/Architecture:
  - Need front end window design (each screen and how it connects/links to other pages) with description of what each page does (basically a wire diagram)
  - Consider integrating Firebase Authentication for account creation, login, and profile management.

![alt text](https://github.com/TaisharTexas/COSC4351_G26_Project/blob/main/image.jpg)

### Notes:
None of us have any experience with using react-like frameworks such as Flutter so this entire project will entail on the fly learning as we progress. Because of this parts of how exactly this design is executed will probably change as we learn more but the core functionality needs remain the same (which is why waterfall is still a valid development method). 
