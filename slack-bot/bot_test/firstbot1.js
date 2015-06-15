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

var newJob;

var messageDictionary = {
    "init_status": {
        action: function(reply) {
            return true;
        },
        response: "Do you want to make a new job(yes/no)?"
    },
    
    "Do you want to make a new job(yes/no)?": {
        action: function(reply) {
            if (reply != "yes") {
                return false;
            }

            newJob = {
                'access_token': 'test',
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
        response: "What kind of job? Design, Writing or Data Entry?",
        error: "Thanks for visiting, you can post job to speedlancer here anytime."
    },
    "What kind of job? Design, Writing or Data Entry?": {
        action: function(reply) {
            if (reply == 'design') {
                newJob['task']['category_id'] = 1;
            } else if (reply == 'writing') {
                newJob['task']['category_id'] = 2;
            } else if (reply == 'data entry') {
                newJob['task']['category_id'] = 3;
            } else {
                return false;
            }

            // newJob['category_id'] = 4;
            return true;
        },
        response: "Please input Job Title (4~140 charaters)"
    },
    "Please input Job Title (4~140 charaters)": {
        action: function(reply) {
            if (reply.length < 4 || reply.length > 140) return false;

            newJob['task']['title'] = reply;
            return true;
        },
        response: "Please input Job Description"
    },
    "Please input Job Description": {
        action: function(reply) {
            if (reply.length < 1) return false;

            newJob['task']['description'] = reply;
            return true;
        },
        response: "Do you have any attachment(if yes, input dropbox url, if no, just input 'no')?"
    },
    "Do you have any attachment(if yes, input dropbox url, if no, just input 'no')?": {
        action: function(reply) {
            if (reply == 'no') return false;

            if (reply[0] == '<' && reply[reply.length - 1] == '>') {
                reply = reply.substring(1, reply.length - 1);
            }

            newJob['attachments'][0] = reply;
            return true;
        },
        response: "Do you have more attachment(if yes, input dropbox url, if no, just input 'no')?",
        error: "post_task"
    },
    "Do you have more attachment(if yes, input dropbox url, if no, just input 'no')?": {
        action: function(reply) {
            if (reply == 'no') return false;

            if (reply[0] == '<' && reply[reply.length - 1] == '>') {
                reply = reply.substring(1, reply.length - 1);
            }

            index = 0;
            for (key in newJob['attachments']) {
                index ++;
            }
            newJob['attachments'][index] = reply;
            return true;
        },
        response: "Do you have more attachment(if yes, input dropbox url, if no, just input 'no')?",
        error: "post_task"
    },
    " ": {
        action: function(reply) {
            return true;
        },
        response: " "
    }

};

var previousResponse;

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
        if (previousResponse) {
            currentResponseObject = messageDictionary[previousResponse];

            result = currentResponseObject.action(currentMessage);

            if (result) {
                previousResponse = currentResponseObject.response;
            } else {
                if (typeof currentResponseObject.error != 'undefined') {
                    if (currentResponseObject.error == "post_task") {
                        postNewJob(newJob, message.channel);
                        errorMessage = "Please wait a second, job is posting now ...";
                        previousResponse = " ";
                    } else {
                        errorMessage = currentResponseObject.error;
                        previousResponse = null;
                    }
                } else {
                    errorMessage = "I can't understand, please read the message carefully.";
                    previousResponse = null;
                }
            }

        }

        if (typeof previousResponse == 'undefined' || !previousResponse) {
            previousResponse = messageDictionary['init_status']['response'];
        }

        var responseMessage = previousResponse;

        if (errorMessage) {
            // responseMessage = errorMessage + "\n" + previousResponse;
            bot.sendMessage(message.channel, errorMessage);
        }

        // bot.sendMessage(message.channel, responseMessage);
        bot.sendMessage(message.channel, previousResponse);
    }
    cb();
});


// function createNewJob(jobType, userId) {
//     var newFreelanceJob = {
//         job: jobType,
//         userId: userId
//     }
//     postNewJob(newFreelanceJob);
// }

function postNewJob(newFreelanceJob, channel) {
    console.log(newFreelanceJob);

    var options = {
        method: 'POST',
        // url: 'https://api.parse.com//1/classes/jobs',
        url: "http://localhost:3000/api/v1/tasks.json",
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
                // console.log("true");
                // return true;
                bot.sendMessage(channel, "Your job is posted successfully.");
            } else {
                // console.log(info['error']);
                // return info['error'];
                bot.sendMessage(channel, "Sorry, operation is failed. Check the following reason.");
                bot.sendMessage(channel, info['error']);
            }
        } else {
            bot.sendMessage(channel, "There's a error on API connection, please try it again.");
        }

        previousResponse = null;
    }

    request(options, callback);
}

// bot.use(function(message, cb) {
//   if ('message' == message.type) {
//     bot.sendMessage('C046S49GZ', message)
//     console.log(bot.channels[0].id);
//   }
//   cb();
// });


bot.connect();