console.time('Execution Time');

var crypto = require('crypto');
var hash = crypto.createHash('sha256');

console.log("Enter the primer: ");
let readline = require('readline-sync');
let gstring = readline.question();
gstring = gstring.replace(/\n/g, ''); 
// check with athassin == b4631093961e867a33244e6ee470e4d04aa9c330cfbff7f22a20eecf71d493de

hash.update(gstring, "ascii");
mhash = hash.digest('hex');
console.log("Original: " + mhash);

let num = 0;
while(mhash >= '00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') {
    hash = null;
    num = num + 1;
    hash = crypto.createHash('sha256');
    hash.update(gstring+String(num), 'ascii');
    mhash = hash.digest('hex');
}
console.log("New hash: " + mhash);
console.log("String: " + gstring + String(num));

console.timeEnd('Execution Time');