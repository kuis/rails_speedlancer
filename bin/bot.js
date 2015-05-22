var slackbot = require('node-slackbot');

var bot = new slackbot('xoxb-4651804618-C87QBd3fNdoz6je2Ebn2JDbr');

bot.use(function(message, cb) {
  if ('message' == message.type) {
    console.log(message.user + ' said: ' + message.text);
  }
  cb();
});

bot.connect();
