'use strict';

const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
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

 