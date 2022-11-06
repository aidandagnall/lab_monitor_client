# Lab Monitor (Client)

<p align="center">
    <img src="./assets/icon/app-logo.png" width="200">
    <br>
        <a href="https://play.google.com/store/apps/details?id=com.aidandagnall.lab_monitor">
            <img src="./assets/images/google-play-badge.png" height="50">
        </a>
        <a href="https://apps.apple.com/gb/app/lab-monitor/id6443952035">
            <img src="./assets/images/appstore-badge.png" height="50">
        </a>
</p>

A Flutter project built show the status of UoN's Computer Science labs for iOS and Android.

This is the client side of the project. The server side can be found [here](https://github.com/aidandagnall/lab_monitor_server).

## Why?

Since I started at UoN, each year's intake has grown. This means labs are more full, and module convenors are often
required to ask students to leave labs to make room. This made it difficult to plan my day - I often could not remember
which labs were on which days, and which I would be asked to leave from. If multiple labs were going on at once, or many
students were displaced, smaller labs may also be full or in-use, forcing me to wander the building in search of a free
space.

This app aims to solve this problem, by providing a way for students to check lab schedules (without needing to be in
the building), and see information about how busy each room is and will be throughout the day. For situations where a
lab may not be booked, but a lab is busy anyway, users can also submit a report about how busy the lab is and letting
other students know.

We've also integrated with the Research Support Team (RST) to allow students to report issues with lab equipment.

## Contributing

If you're a UoN student, you are welcome to use the existing endpoints and URLs
for client-only changes. For changes that effect client and server, you
will need to use debug mode and run your own server locally.

If you're a non-UoN student, you will need to provide the authentication server
yourself. For this project, we have opted to use Auth0, and the app is built with
this in mind. If you'd like to work with me to create an authentication facade, or
to help make the app more generic in other ways, please get in touch.

## Getting Started

Create a `.env` file by copying the `.env.example` file, and updating the `DEBUG_API_URL` value to the URL of the local
[server](https://github.com/aidandagnall/lab_monitor_server) that you are running.

Then, use `flutter run` to run the app.

## Contributors

- Aidan Dagnall - [aidandagnall](https://github.com/aidandagnall)
- Jozef Sieniawski - [jozefws](https://github.com/jozefws)
