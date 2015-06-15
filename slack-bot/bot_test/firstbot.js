var slackbot = require('../');
var request = require('../node_modules/request');

// var inputToken = 'xoxb-4480955449-CS2YqxcmAQzDIY56pqQqEHlS'; // The default token for Grant's slack channel.
var inputToken = 'xoxb-6075499078-Q98VXd8XZOIG5OdXWTAQmBS7';

process.argv.forEach(function (val, index, array) {
    if (index == 2) {
        inputToken = val; // The token that can be entered as a command line argument.
    }
});

var bot = new slackbot(inputToken);
var botname;
var team;

// listen in any channel
// be able to address bot with @botname instead of having to type 'new job'
// be able to type @botname category and be able to skip the category step
bot.api("auth.test",{},function(data){
    if (data.ok) {
        botname = data.user_id;
        console.log("Connected to bot: " + botname + "!");

        team = data.team;
    }
});

var newJobs = {};

var messageDictionary = {
    "init_status": {
        action: function(reply, channel) {
            return true;
        },
        response: "Howdy! Would you like to post a new task? (Yes/No)"
    },
    "timeout_status": {
        response: "Shido timed out. Would you like to resume posting (yes/no)?"
    },
    "bye_status": {
        response: "Howdy there, I’m Shido! Please tell me what you need, when you need it, and I'll make sure it's done in 4 hours! Did I mention I don’t sleep?"
    },

    "Howdy there, I’m Shido! Please tell me what you need, when you need it, and I'll make sure it's done in 4 hours! Did I mention I don’t sleep?": {
        action: function (reply, channel) {
            return true;
        },
        response: "Howdy! Would you like to post a new task? (Yes/No)"
    },
    
    "Howdy! Would you like to post a new task? (Yes/No)": {
        action: function(reply, channel) {
            if (reply != "yes") {
                return false;
            }

            newJobs[channel] = {
                // 'access_token': 'test',
                'access_token': '4882497303',
                'task': {
                    'price_in_dollars': 39.00,
                    'source': 'slack',
                    'payment_method': 'credits'
                },
                'buyer': {
                    // 'email': 'test@gmail.com',
                    // 'name': 'tester'
                    'bot_key': inputToken
                },
                'attachments':{},
            };
            
            return true;
        },
        response: "Woo. Ok, what kind of job? (Design, Writing or Data Entry)",
        error: "Howdy there, I’m Shido! Please tell me what you need, when you need it, and I'll make sure it's done in 4 hours! Did I mention I don’t sleep?",
        preparation: true
    },
    "Woo. Ok, what kind of job? (Design, Writing or Data Entry)": {
        action: function(reply, channel) {
            if (reply == 'design') {
                newJobs[channel]['task']['category_id'] = 1;
            } else if (reply == 'writing') {
                newJobs[channel]['task']['category_id'] = 2;
            } else if (reply == 'data entry') {
                newJobs[channel]['task']['category_id'] = 3;
            } else if (reply == 'four') {
                newJobs[channel]['task']['category_id'] = 4;
            } else {
                return false;
            }

            return true;
        },
        response: "Ok, that’ll be $39. Please type ‘yes’ to authorize a $39 deduction from your Speedlancer account."
    },
    "Ok, that’ll be $39. Please type ‘yes’ to authorize a $39 deduction from your Speedlancer account.": {
        action: function(reply, channel) {
            if (reply != 'yes') {
                return false;
            }
            return true;
        },
        response: "What kind of task? (4-140 character title)",
        error: "I’m here 24/7, so let me know when you’re ready to post a task!"
    },
    "What kind of task? (4-140 character title)": {
        action: function(reply, channel) {
            if (reply.length < 4 || reply.length > 140) return false;

            newJobs[channel]['task']['title'] = reply;
            return true;
        },
        response: "Cool. Please tell us exactly what you need (long description)"
    },
    "Cool. Please tell us exactly what you need (long description)": {
        action: function(reply, channel) {
            if (reply.length < 1) return false;

            newJobs[channel]['task']['description'] = reply;
            return true;
        },
        response: "Would you like to include an attachment? (if yes, input DropBox url; otherwise type 'no')"
    },
    "Would you like to include an attachment? (if yes, input DropBox url; otherwise type 'no')": {
        action: function(reply, channel) {
            if (reply == 'no') return false;

            if (reply[0] == '<' && reply[reply.length - 1] == '>') {
                reply = reply.substring(1, reply.length - 1);
            }

            newJobs[channel]['attachments'][0] = reply;
            return true;
        },
        response: "Noted. Any other attachments? (if yes, input DropBox url; otherwise 'no')",
        error: "post_task"
    },
    "Noted. Any other attachments? (if yes, input DropBox url; otherwise 'no')": {
        action: function(reply, channel) {
            if (reply == 'no') return false;

            if (reply[0] == '<' && reply[reply.length - 1] == '>') {
                reply = reply.substring(1, reply.length - 1);
            }

            index = 0;
            for (key in newJobs[channel]['attachments']) {
                index ++;
            }
            newJobs[channel]['attachments'][index] = reply;
            return true;
        },
        response: "Do you have more attachment(if yes, input dropbox url, if no, just input 'no')?",
        error: "post_task"
    },
    " ": {
        action: function(reply, channel) {
            return true;
        },
        response: " ",
        preparation: true
    },

    "Shido timed out. Would you like to resume posting (yes/no)?":{
        action: function (reply, channnel) {
            if (reply != 'yes') {
                return false;
            }
            return true;
        },
        error: "Howdy there, I’m Shido! Please tell me what you need, when you need it, and I'll make sure it's done in 4 hours! Did I mention I don’t sleep?",
        preparation: true
    }

};

var previousResponses = {};

var interval = setInterval(function() {
    var timeout = 1000 * 30;

    for (channel in previousResponses) {
        var previousRes = previousResponses[channel];

        if (!previousRes) {
            continue;
        }

        var status = previousRes.status;
        var activeAt = previousRes.activeAt;

        if (messageDictionary[status]['preparation'] !== true) {
            if (new Date().getTime() - activeAt > timeout) {
                bot.sendMessage(channel, messageDictionary['timeout_status']['response']);

                previousResponses[channel] = {
                    status: messageDictionary['timeout_status']['response'],
                    activeAt: new Date().getTime(),
                    response: status
                }
            }
        }
    }
}, 10*1000);

bot.use(function (message, cb) {
    // console.log("USER:" + message.user);
    // console.log("message.type = " + message.type);
    // console.log("bot.channels[0].id = " + bot.channels[0].id);
    // console.log(bot.channels);
    var is_for_me = false;

    var currentMessage;

    if (botname && message.type == 'message') { // Check if this message is for this bot

        currentMessage = message.text.trim();

        var channelType = message.channel[0]; //G:group, C:general, D:direct
        if (channelType == 'D') {
            is_for_me = true;
        } else {
            var to_me_mark = "<@"+botname+">:";
            if (currentMessage.indexOf(to_me_mark) == 0) {
                currentMessage = currentMessage.substring(to_me_mark.length);
                is_for_me = true;
            }
        }
    }

    // if ('message' == message.type && bot.channels[0].id == message.channel && message.user != 'U04E4U3D7') {
    if (is_for_me) {
        
        var currentResponseObject;

        currentMessage = currentMessage.toLowerCase().trim();

        console.log("Message to me: " + currentMessage);
        
        var errorMessage;
        if (previousResponses[message.channel]) {
            currentResponseObject = messageDictionary[previousResponses[message.channel]['status']];

            result = currentResponseObject.action(currentMessage, message.channel);

            if (result) {
                if (currentResponseObject.response) {
                    previousResponses[message.channel] = {
                        status: currentResponseObject.response,
                        activeAt: new Date().getTime()
                    }
                } else {
                    if (previousResponses[message.channel].response) {
                        var response = previousResponses[message.channel].response;
                        previousResponses[message.channel] = {
                            status: response,
                            activeAt: new Date().getTime()
                        }
                    } else {
                        previousResponses[message.channel] = null;
                    }
                }
            } else {
                if (typeof currentResponseObject.error != 'undefined') {
                    if (currentResponseObject.error == "post_task") {
                        postNewJob(newJobs[message.channel], message.channel);
                        errorMessage = "Please wait a second, job is posting now ...";
                        previousResponses[message.channel] = {
                            status: " ",
                            activeAt: new Date().getTime()
                        }
                    } else {
                        errorMessage = currentResponseObject.error;
                        previousResponses[message.channel] = null;
                    }
                } else {
                    errorMessage = "Oh golly I don't speak Klingon. Could you try that again?";
                    previousResponses[message.channel] = null;
                }
            }

        }

        if (typeof previousResponses[message.channel] == 'undefined' || !previousResponses[message.channel]) {
            // previousResponses[message.channel] = messageDictionary['init_status']['response'];
            previousResponses[message.channel] = {
                status: messageDictionary['init_status']['response'],
                activeAt: new Date().getTime()
            }
        }

        if (errorMessage) {
            // responseMessage = errorMessage + "\n" + previousResponse;
            bot.sendMessage(message.channel, errorMessage);
        }

        // bot.sendMessage(message.channel, responseMessage);
        bot.sendMessage(message.channel, previousResponses[message.channel]['status']);
    }
    cb();
});



function postNewJob(newFreelanceJob, channel) {
    console.log(newFreelanceJob);

    var options = {
        method: 'POST',
        // url: "http://localhost:3000/api/v1/tasks.json",
        url: "http://app.speedlancer.com/api/v1/tasks.json",
        headers: {
            // 'X-Parse-Application-Id': 'yvHvEkne9jgX5ld3Gc2m3X9dC6ykkZq5aAYcyXKY',
            // 'X-Parse-REST-API-Key': 'xn6eb48pKothnOnhZNJRW12pX6x5GZ4nVJXwwCaE',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(newFreelanceJob)
    };

    function callback(error, response, body) {
        if (!error && response.statusCode == 200 ) {
            info = JSON.parse(body);
            if (info['status'] == 'success') {
                bot.sendMessage(channel, "Awesome sauce. Your task has been submitted to my network of Speedlancers and you’ll be updated of its progress by email. Good day!");
            } else {
                bot.sendMessage(channel, "Oh no. Looks like you’ve run out of cheese. Please head to http://My.Speedlancer.com to top up your account and then re-post");
                bot.sendMessage(channel, info['error']);
            }
        } else {
            bot.sendMessage(channel, "There's a error on API connection, please try it again.");
        }

        previousResponses[channel] = null;
    }

    request(options, callback);
}


bot.connect();