## Install

```sh
$ npm install --save node-slackbot
```


## Usage

```js
var slackbot = require('node-slackbot');

var bot = new slackbot('token_goes_here');

bot.use(function(message, cb) {
  if ('message' == message.type) {
    console.log(message.user + ' said: ' + message.text);
  }
  cb();
});

bot.connect();
```

## Rails Integration

In the controller, launch the bot from the command line after accessing the bot_test directory. Pass in the user's RTM API token as well so the bot knows which slack channel to connect to.

For example:

exec('adam-node-slackbot/bot_test/firstbot.js xoxb-4480955449-CS2YqxcmAQzDIY56pqQqEHlS')