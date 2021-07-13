# Social media app with Ruby on Rails

> This is a social media app featuring Friendships, friendship request, posts, comments and likes.

## Built With

- Ruby v2.7.0
- Ruby on Rails v5.2.4

## Live Demo

TBA

## Screenshot
![All Users Page](assets/images/Ror-all-users.png)
![Timeline](assets/images/Ror-timeline.png)


## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

- Ruby v2.7.0
- Ruby on Rails v5.2.4
- Postgres: >=9.5

**This project is not supported by ruby 3.x or rails 6.x**

### Setup

Install gems with dependancies:

```
bundle install
```

Setup database with:

**Configure postgress for the database to work**

```
   rails db:create
   rails db:migrate
```

### Usage

Start server with:

```
    rails server
```

Open `http://localhost:3000/` in your browser.

### Run tests
Run test from the project root directory
- `bundle exec rpsec` to run all the test
- `bundle exec rspec spec/models` to run unit tests
- `bundle exec rspec spec/features` to run integration tests.

**Chrome is needed to run the integration tests**


### Deployment

To be done in the next milestone.

## Authors
👤 **Ihedoro Fortunatus**

- GitHub: [@fortuneonyeka](https://github.com/fortuneonyeka/)
- Twitter: [@onyekafortune](https://twitter.com/AngelaCunaDev)
- LinkedIn: [@fortunatus-ihedoro](https://www.linkedin.com/in/fortunatus-ihedoro/)

👤 **Lucas Ferrari Soto**

- GitHub: [@notlfish](https://github.com/notlfish)
- Twitter: [@LucasFerrariSo1](https://twitter.com/LucasFerrariSo1)
- LinkedIn: [LinkedIn](https://www.linkedin.com/in/lucas-mauricio-ferrari-soto-472a3515a/)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

This code is a project for [Microverse](https://www.microverse.org/), and its specification was taken from [The Odin Project](https://www.theodinproject.com/home)

## 📝 License

This project is [MIT](./LICENSE) licensed.
