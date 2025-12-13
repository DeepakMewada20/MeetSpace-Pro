import { onRequest, onCall } from "firebase-functions/v2/https";
import * as dotenv from "dotenv";
import { initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";


//app config data fetch
dotenv.config();
export const testFunction = onRequest((req, res) => {
  const appSign = process.env.APP_SIGN;
  const appId = parseInt(process.env.APP_ID);

  res.send({
    appSign,
    appId,
  });
});

//notification send function

initializeApp();

export const sendNotificationToDevice = onCall(
  async (request) => {

    const data = request.data;
    const targetToken = data.token;
    const meetingId = data.mettingID;

    const message = {
      token: targetToken,
      notification: {
        title: "Meeting Started",
        body: "Tap to join meeting",
      },
      data: {
        type: "mettingID",
        mettingID: meetingId.toString(),
      },
      android: {
        priority: "high",
      },
    };

    await getMessaging().send(message);

    return { success: true };
  }
);
