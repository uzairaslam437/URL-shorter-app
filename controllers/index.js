const nanoId = require("nano-id");
const URL = require("../models/url");

async function handleGenerateShortUrl(req, res) {
  const body = req.body;

  if (!body.Url) {
    return res.status(400).json({ status: `Url is required` });
  }

  const shortId = nanoId(8);
  try {
    await URL.create({
      shortId: shortId,
      redirectUrl: body.Url,
      visitHistory: [],
    });
  } catch (error) {
    console.error("Error creating URL:", error);
    return res.status(500).json({ status: "Error creating URL" });
  }

  return res.json({ id: shortId });
}

async function handleGetAnalytics(req,res){
  const shortId = req.params.shortId;
  const result  = await URL.findOne({shortId});
  return res.json({
    totalClicks: result.visitHistory.length,
    analytics:   result.visitHistory 
  })
}

module.exports = { handleGenerateShortUrl,
                   handleGetAnalytics
 };
