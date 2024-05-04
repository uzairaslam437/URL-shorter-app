const express = require("express");
const app = express();
const PORT = 8000;
const router = require("./routes/url");
const URL = require("./models/url");
const { connectMongoDb } = require("./connection");

connectMongoDb("mongodb://localhost:27017/new");

app.use(express.json());

app.use("/user", router);

app.get("/:shortId", async (req, res) => {
  const shortId = req.params.shortId;
  const entry = await URL.findOneAndUpdate(
    {
      shortId,
    },
    {
      $push: {
        visitHistory: {
          timestamp: Date.now(),
        },
      },
    }
  );
  if (entry.redirectUrl) {
    res.redirect('https://' + entry.redirectUrl);
  } else {
    console.error("Entry or redirectUrl is null");
    res.status(404).send("URL not found");
  }
});



app.listen(PORT, () => {
  console.log(`Connected to the port:${PORT}`);
});
