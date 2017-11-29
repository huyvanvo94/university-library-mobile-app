'use strict';

const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const schedule = require('node-schedule');
// Configure the email transport using the default SMTP transport and a GMail account.
// For Gmail, enable these:
// 1. https://www.google.com/settings/security/lesssecureapps
// 2. https://accounts.google.com/DisplayUnlockCaptcha
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;
const mailTransport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword
  }
});

 
exports.sendGeneralEmail = functions.https.onRequest((req, res) => {
	var email = req.query.email;
	var text = req.query.text; 
	var subject = req.query.subject;

	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        to: email,
        subject: subject,
        text: text 
    };

    mailTransport.sendMail(mailOptions, function(error, info){
        if (error) { 
            res.send(error);
         } else { 
            res.send("Message success");
         }
     });
 });

exports.confirmCheckout = functions.https.onRequest((req, res) => {
	var email = req.query.email;
	var transactionTime = req.query.transactionTime;
	var dueDate = req.query.dueDate;
	
	
	var message = "Checkout Confirmation: " + "<br>Checkout Time: " + transactionTime + "<br>Due Date: " + dueDate;
	
	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        to: email,
        subject: "Checkout Confirmation",
        html: message
    };
	
	 mailTransport.sendMail(mailOptions, function(error, info){
        if (error) { 
            res.send(error);
         } else { 
            res.send("Message success");
         }
     });
	
});

exports.returnBooks = functions.https.onRequest((req, res) =>{
	var data = req.query.data;
	var email = req.query.email;
	
	//parse json
	var parsedData = JSON.parse(data);
	var message = "Return Confirmation: ";

	for(var i in parsedData){
		message += "<br>Title:" + parsedData[i].nameOfBook + " Fine Amount: " + parsedData[i].fineAmount;
	}
	
	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        to: email,
        subject: "Return Confirmation",
        html: message
    };
	
	mailTransport.sendMail(mailOptions, function(error, info){
        if (error) { 
            res.send(error);
         } else { 
            res.send("Message success");
         }
     });
	
	
});

exports.mock_scheduledEmail = functions.https.onRequest((req, res) =>{
	var startTimeInterval = req.query.twentyFiveDaysFromNowTimeInterval;
	var endTimeInterval = req.query.thirtyDaysFromNowTimeInterval;
	var email = req.query.email;
	
	var startTime = new Date(parseInt(startTimeInterval)) ;
	var endTime = new Date(parseInt(endTimeInterval));
	
	res.send(startTime);

	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        to: email,
        subject: "Return Reminder",
		text: "sup"
    };

//every minute
var j = schedule.scheduleJob({ start: startTime, end: endTime, rule: '* */1 * * * *' }, function(){
	mailTransport.sendMail(mailOptions);
}});

	
});

exports.scheduledEmail = functions.https.onRequest((req, res) => {
	var startTimeInterval = req.query.twentyFiveDaysFromNowTimeInterval;
	var endTimeInterval = req.query.thirtyDaysFromNowTimeInterval;
	var email = req.query.email;
	
	var startTime = new Date(parseInt(startTimeInterval));
	var endTime = new Date(parseInt(endTimeInterval));
	
	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        to: email,
        subject: "Return Reminder",
		text = "sup"
    };

	
	var test = schedule.scheduleJob({start: startTime, end: endTime, rule: '*/1440 * * * * *', function(){
		mailTransport.sendMail(mailOptions);
	}});
	
	
});


