//open itemIds json file and read it, make sure every value for every key is in sequence, replace the value with the sequence number

var fs = require("fs");
var path = require("path");
var _ = require("underscore");

var itemIds = JSON.parse(
  fs.readFileSync(path.join(__dirname, "itemIds.json"), "utf8")
);

// for every itemIds key make replace the value with its sequence number starting from 1
let count = 1;
_.each(itemIds, function (value, key) {
  if (itemIds[key] !== null) {
    itemIds[key] = count;
    count++;
  }
});

// write the new itemIds json file
fs.writeFileSync(
  path.join(__dirname, "itemIds.json"),
  JSON.stringify(itemIds, null, 2),
  "utf8"
);
