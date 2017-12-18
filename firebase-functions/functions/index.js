'use strict';
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const schedule = require('node-schedule');
// Configure the email transport using the default SMTP transport and a GMail account.
// For Gmail, enable these:
// 1. https://www.google.com/settings/security/lesssecureapps
// 2. https://accounts.google.com/DisplayUnlockCaptcha
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
admin.initializeApp(functions.config().firebase);
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


exports.helloWorld = functions.https.onRequest((req, res) => {
	res.send("Hello world");
	
});


exports.confirmCheckout = functions.https.onRequest((req, res) => {
	var bookInfo = req.query.bookInfo;
	var email = req.query.email;
	var transactionTime = req.query.transactionTime;
	var dueDate = req.query.dueDate;
	
	
	var message = "Checkout Confirmation: " + "<br>Book Title: " 
	+ bookInfo + "<br>Checkout Time: " + transactionTime + "<br>Due Date: " + dueDate;
	
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
		message += "<br><br>Title:" + parsedData[i].nameOfBook + "<br>Fine Amount: " + parsedData[i].fineAmount;
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
	const currentDate = Date.now(); //returns # of ms since Jan 1 1970
	
	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        subject: "Return Reminder"
    };
	//need admin SDK to read db
	const ref = admin.database().ref("checkout_list");
	
	ref.once("value")
		.then(function(snapshot){
			snapshot.forEach(function(childSnapshot){
				//looping through book child nodes in checkout_list now				
				childSnapshot.child("users").forEach(function(userSnapshot){
					//looping through users of each book node in checkout_list
					var dueDate = parseInt(userSnapshot.child("dueDate").val() * 1000);
						//check if dueDate is within 5 days from today
						if(true){
							//send an email for every user if cond matches
							mailOptions.to = userSnapshot.child("email").val();
							mailOptions.text = "hi, you have a book due at: " + Date(dueDate);
							mailTransport.sendMail(mailOptions);
						}
				});
				
			});
		});
		res.send("Success");
	
	//loop through db every 24 hrs
	/*
	var j = schedule.scheduleJob({ start: startTime, end: endTime, rule: '* * * * * *' }, function(){
	
	var currentDate = Date.now();
	ref.once("value")
		.then(function(snapshot){
			snapshot.forEach(function(childSnapshot){
				//looping through book child nodes in checkout_list now				
				childSnapshot.child("users").forEach(function(userSnapshot){
					//looping through users of each book node in checkout_list
					var dueDate = userSnapshot.child("dueDate").val();
						//check if dueDate is within 5 days from today
						if(dueDate - currentDate < 432000000){
							//send an email for every user if cond matches
							mailOptions.to = userSnapshot.child("email").val();
							mailOptions.text = "hi, you have a book due at: " + Date(dueDate);
							mailTransport.sendMail(mailOptions);
						}
				});
				
			});
		});
	*/
});


exports.scheduledEmail = functions.https.onRequest((req, res) => {
	//const currentDate = Date.now(); //returns # of ms since Jan 1 1970
	
	var mailOptions = {
        from: "universitylibrary-8e17c<noreply@firebase.com>",
        subject: "Return Reminder"
    };
	//need admin SDK to read db
	const ref = admin.database().ref("checkout_list");
	/*
	ref.once("value")
		.then(function(snapshot){
			snapshot.forEach(function(childSnapshot){
				//looping through book child nodes in checkout_list now				
				childSnapshot.child("users").forEach(function(userSnapshot){
					//looping through users of each book node in checkout_list
					var dueDate = parseInt(userSnapshot.child("dueDate").val() * 1000);
						//check if dueDate is within 5 days from today
						if(dueDate - currentDate < 432000000){
							//send an email for every user if cond matches
							mailOptions.to = userSnapshot.child("email").val();
							mailOptions.text = "hi, you have a book due at: " + Date(dueDate);
							mailTransport.sendMail(mailOptions);
						}
				});
				
			});
		});*/
		
	
	//loop through db every 24 hrs, /24 after third asterisk
	
	var j = schedule.scheduleJob({ start: startTime, end: endTime, rule: '* * */24 * * *' }, function() {
        var currentDate = Date.now();
        ref.once("value")
            .then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    //looping through book child nodes in checkout_list now
                    childSnapshot.child("users").forEach(function (userSnapshot) {
                        //looping through users of each book node in checkout_list
                        var dueDate = userSnapshot.child("dueDate").val();
                        //check if dueDate is within 5 days from today
                        if (dueDate - currentDate < 432000000) {
                            //send an email for every user if cond matches
                            mailOptions.to = userSnapshot.child("email").val();
                            mailOptions.text = "Hello good sir, you have a book due at: " + Date(dueDate);
                            mailTransport.sendMail(mailOptions);
                        }
                    });

                });
            });
    });
	
	res.send("Success");
});
		

	

