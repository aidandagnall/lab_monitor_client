# Lab Monitor Client

<p align="center">
    <img src="./assets/icon/app-logo.png" width="200">
</p>

A Flutter project built show the status of UoN's Computer Science labs.

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

## Contributing

Create a `.env` file by copying the `.env.example` file, and updating the `DEBUG_API_URL` value to the URL of the local
[server](https://github.com/aidandagnall/lab_monitor_server) that you are running. Either clone and run this yourself,
or use the existing server at `https://uon-lab-monitor.herokuapp.com` if you're only working on the client.

```bash
cp .env.example .env
```

Then, run `flutter run` to run the app.
