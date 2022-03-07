const assert = require('assert');
const fs = require('fs');

const search = (node) => {
  if (typeof node !== 'object' || node == null) return null;
  if (node?.class === '^discord$') return node;

  return Object.values(node).reduce((acc, e) => acc ?? search(e), null);
};

const path = process.argv[2];
assert.strictEqual(typeof path, 'string', 'must provide path as argument');

const layout = require(path);
const discordNode = search(layout);

if (discordNode !== null) {
  discordNode.title = '^Discord$';
  fs.writeFile(path, JSON.stringify(layout), () => {});
}
