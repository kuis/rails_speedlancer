# API documentation for [Speedlancer](http://app.speedlancer.com) API v1.0


1. To hit Speedlancer API first step is authenticate for accessing api.
2. We will generate and assign that token without token no application could access API. This `access_token` should be present in every call.
3. Speedlancer version 1 url is `http://app.speedlancer.com`.

## Creating tasks

* In parameters `access_token` should be present.
* Url for creating the tasks:- `/api/v1/tasks.json`. Request type is `POST`.
* Title, description, category id, price in dollars everything is required else task will return errors.
* Make sure in ROR application has category with the id you are passing in call.
* Add all the URL of uploaded files in attachments hash with attachments url to upload.
Sample call:-

```json
{
  access_token: "your_access_token"
  -task: {
    title: "Create a logo",
    description: "Create logo for my website",
    category_id: "3",
    price_in_dollars: "15.4",
    attachments: {"1" => "attachments.jpg", "2" => "attachments2.jpg"}
  }
  -buyer:{
    email: "peeyush@speedlancer.com",
    name: "Peeyush Singla"
  }
}

```
Successful call:-

```Json
{
  "status": "success",
  "payment_url": "https://www.sandbox.paypal.com/cgi-bin/webscr?amount=12.04&business=rahul-buyer%40fizzysoftware.com&cmd=_xclick&invoice=1086-2015-03-26-17-20-47-0530&item_name=title+is+here&item_number=1086&notify_url=http%3A%2F%2F6b7a4122.ngrok.com%2Fhook&on0=&on1=true&return=http%3A%2F%2F6b7a4122.ngrok.comhttp%3A%2F%2Fspeedlancer.com&upload=1"
}
```
* Payment url is the url to redirect for payment.
* Once done task will be activated and if buyer don't have account same will be confirmed.
* Credentials for login will be sent via email.

Unsuccessful call Cases:-

* Call unsuccessful because of the invalid token:

```json
{
  "status": "failure",
  "error": "Invalid access token"
}
```

* If value of task is nov valid:
```json
{
  "status": "failure",
  "error":
    [
      "Price in dollars must be greater than 0.01"
    ]
}

```
* If buyer email not present:

```json
{
  "status": "failure",
  "error": "Please add email for buyer"
}

```





