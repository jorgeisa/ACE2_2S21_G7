const SerialPort = require("serialport");
const Readline = require("@serialport/parser-readline");
const port = new SerialPort("COM5", { baudRate: 9600 });
const parser = port.pipe(new Readline({ delimiter: "\n" }));

const express = require("express");
const app = express();
const serverPort = 4000;

const MongoClient = require("mongodb").MongoClient;
const url = "mongodb://localhost:27017";

app.listen(serverPort, () => console.log(`Server on port ${serverPort}`));

app.get('/', function (req, res) {
  MongoClient.connect(url, async (err, db) => {
    if (err) throw err;
    const dbo = db.db("mydb");
    const myArray = await dbo.collection("measures").find({}).toArray();
    db.close();
    res.json(myArray[myArray.length - 1]);
  });
})

port.on("open", () => {
  console.log("serial port abierto");
});

parser.on("data", (data) => {
  console.log(`Se lee ${data}`);

  if (data !== undefined) {
    try {
      const obj = JSON.parse(data);
      if(obj !== undefined){
        insertData(data);
      }
      
    } catch (err) {
      console.log("ERROR");
    }
  }
});

function insertData(data) {
  console.log("Inserta: ")
  MongoClient.connect(url, (err, db) => {
    if (err) throw err;
    const dbo = db.db("mydb");
    const obj = JSON.parse(data);
    dbo.collection("measures").insertOne(obj, (err, res) => {
      if (err) throw err;
      db.close();
    });
  });
}



//Temperatura*Humedad*