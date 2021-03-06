# Final Project- *HelpDesk*

**HelpDesk** allows students at Washington Univeristy to connect to tutors and view available help sessions for the classes they are enrolled in.

Time spent: **So many** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] Users can sign up and login with email and password
- [X] Users can use the app as either a student or a tutor
- [X] Students can make a request to the WashU School of Engineering for a tutors
- [X] When assigned, students and tutors are directly connected to each other
- [X] Tutors and students can message eachother directly.
- [X] Tutors and students can use an appointment making tool to decide on meet up times, locations (using mobile maps), and topics.
- [X] Students can use the app to send a "cancelation" notification

The following **optional** features are implemented:

- [ ] Users can opt to have appointments exported to their calendars and receive reminder notifications
- [ ] List of open help sessions hosted by the university
- [ ] Full list of classes that offer tutoring services
- [ ] Integration with Cornerstone (WashU academic help center)

## Wireframe

Here's a wireframe of the potential app layout:

<img src='http://i.imgur.com/8YwAs2Q.jpg' title='Wireframe' width='' alt='Video Walkthrough' />

## Parse Server Details
- User Table:
    -Default parse user table
    -courses tutored
- Notifcation:
    -student
    -tutor
    -subject
    -type
    -location
    -mapUsed
    -time
    -longitude
    -latitude
    -topics
    -read
- Messages:
    -Text
    -Sender
    -Receiver
    -isSeen
    -isDelivered
- Tutoring:
    -Tutor Name
    -Student Name
    -Subject
    -Type
    -Message

## Video Walkthrough 

Here's an updated walkthrough of implemented user stories:

<img src='http://i.imgur.com/CBT6cWZ.gif' title='Video Walkthrough 2' width='' alt='Video Walkthrough 3' />

Here's an updated walkthrough of implemented user stories:

<img src='http://i.imgur.com/fjqbTL4.gif' title='Video Walkthrough' width='' title='Video Walkthrough 3' alt='Video Walkthrough'/>

GIFs created with [LiceCap](http://www.cockos.com/licecap/).

## License

    Copyright 2016 Michael Madans, Zach Glick, Reis Sirdas

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
