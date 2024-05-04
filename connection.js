const mongoose = require("mongoose")

function connectMongoDb(url){
    return mongoose.connect(url)
    .then(console.log(`Mongo Db Connected`))
    .catch((err)=>{
        console.log(`Error:`,err)
    })
}

module.exports = {connectMongoDb}