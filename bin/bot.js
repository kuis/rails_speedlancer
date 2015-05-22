process.argv.forEach(function(val, index, array) {
  if (index == 2) {
    inputToken = val;
  }
});

var slackbot = require('node-slackbot');

var bot = new slackbot(inputToken);

bot.use(function(message, cb) {
  if ('message' == message.type) {
    console.log(message.user + ' said: ' + message.text);
  }
  cb();
});

bot.connect();
