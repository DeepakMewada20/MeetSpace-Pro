import { onRequest } from "firebase-functions/v2/https";
import * as dotenv from "dotenv";

dotenv.config();

export const testFunction = onRequest((req, res) => {
  const appSign = process.env.APP_SIGN;
  const appId = parseInt(process.env.APP_ID);

  res.send({
    appSign,
    appId,
  });
});
