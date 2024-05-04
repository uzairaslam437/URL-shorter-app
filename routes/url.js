const express = require("express")
const router =  express.Router()
const {handleGenerateShortUrl,
       handleGetAnalytics
} = require("../controllers/index")

router.post("/",handleGenerateShortUrl)

router.get("/analytics/:shortId",handleGetAnalytics)

module.exports = router;