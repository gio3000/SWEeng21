# Dualis Api

This is a simple api to get your grades from the [Dualis](https://dualis.dhbw.de) website.

## Setup

1. Clone the repository
2. Go into the directory with `cd <Path-to-Repo>/dualis-api`
3. Install the dependencies with `npm install`
4. Setup the credentials in the .env file (see .env.example). The JWT_KEY has to be the same as the used in the Backend
5. Start the server with `npm run start`

## Usage
Send a POST request to the server on your Port (default 3000) with the following JSON body:

```json
{
    "coursename": "your coursename",
    "students": [
        {
            "firstname": "student firstname",
            "lastname": "student lastname",
            "email": "student email",
            "password": "student password",
            "matriculationnumber": "student matriculationnumber"
        }
    ]
}
```

The email and password have to be the same as the ones you use to login to Dualis.
