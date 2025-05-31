const functions = require("firebase-functions/v1"); // ✅ use v1 for legacy syntax
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const logger = require("firebase-functions/logger");

admin.initializeApp();

// Gmail Transporter Setup
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "muhammadfayiskm31@gmail.com",
    pass: "vrwr elqt yova hhkl", // Use your App Password securely!
  },
});

// ✅ Emergency Booking Email Function
exports.sendEmergencyBookingEmail = functions.firestore
  .document("emergency_requests/{requestId}")
  .onCreate(async (snap) => {
    const data = snap.data();

    if (!data || !data.userEmail || !data.serviceName) {
      logger.error("Missing emergency booking data. Cannot send email.");
      return;
    }

    const mailOptions = {
      from: "FixMyRide <fixmyride.services.com>",
      to: data.userEmail,
      subject: "Emergency Booking Confirmation",
      html: `
        <p>Hello, ${data.userName}  (${data.userEmail})</p>
        <p>Your emergency booking has been received successfully.</p>
        <ul>
          <li><strong>Service:</strong> ${data.serviceName}</li>
          <li><strong>Vehicle:</strong> ${data.vehicle}</li>
          <li><strong>Description:</strong> ${data.description}</li>
          <li><strong>Location:</strong> ${data.latitude}, ${data.longitude}</li>
          <li><strong>Maps:</strong> https://www.google.com/maps?q=${data.latitude},${data.longitude} </li>
          <li><strong>Phone:</strong> ${data.userPhone}</li>
        </ul>
        <p>We will contact you shortly.</p>
        <p>Team Fix My Ride.</p>
      `,
    };

    try {
      await transporter.sendMail(mailOptions);
      logger.info("Emergency email sent to:", data.userEmail);
    } catch (error) {
      logger.error("Error sending emergency email:", error);
    }
  });

// ✅ Maintenance Booking Email Function
exports.sendMaintenanceBookingEmail = functions.firestore
  .document("maintenance_requests/{requestId}")
  .onCreate(async (snap) => {
    const data = snap.data();

    if (!data || !data.userEmail || !data.serviceName) {
      logger.error("Missing maintenance booking data. Cannot send email.");
      return;
    }


    const mailOptions = {
      from: "FixMyRide <fixmyride.services.com>",
      to: data.userEmail,
      subject: "Maintenance Booking Confirmation",
      html: `
        <p>Hello, ${data.userName} - (${data.userEmail})</p>
        <p>Your maintenance booking has been received successfully.</p>
        <ul>
          <li><strong>Service:</strong> ${data.serviceName}</li>
          <li><strong>Vehicle:</strong> ${data.vehicle}</li>
          <li><strong>Description:</strong> ${data.description}</li>
          <li><strong>Date:</strong> ${data.date || "Not specified"}</li>
          <li><strong>Time:</strong> ${data.time || "Not specified"}</li>
          <li><strong>Phone:</strong> ${data.userPhone}</li>
        </ul>
        <p>We will contact you shortly.</p>
        <p>Team Fix My Ride.</p>

      `,
    };

    try {
      await transporter.sendMail(mailOptions);
      logger.info("Maintenance email sent to:", data.userEmail);
    } catch (error) {
      logger.error("Error sending maintenance email:", error);
    }
  });
