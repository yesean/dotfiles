const fs = require('fs');
const path = process.argv[2];

const layoutObj = require(path);

let discordNode = null;
const search = (obj) => {
  const isArray = Array.isArray(obj);
  const isObject = typeof obj === 'object' && obj !== null;
  if (isArray) {
    obj.forEach(search);
  } else if (isObject) {
    Object.entries(obj).forEach(([key, val]) => {
      if (key === 'swallows' && Array.isArray(val)) {
        const swallowsObj = val[0];
        if (
          typeof swallowsObj === 'object' &&
          swallowsObj !== null &&
          swallowsObj.class === '^discord$'
        ) {
          discordNode = obj;
        }
      }
      search(val);
    });
  }
};

search(layoutObj);
if (discordNode !== null) {
  console.log(discordNode.swallows);
  discordNode.swallows[0].title = '^Discord$';
  console.log(discordNode.swallows);
  fs.writeFile(path, JSON.stringify(layoutObj), () => {});
}
