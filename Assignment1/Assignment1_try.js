// var gstring = "";
// const readline = require('readline').createInterface({
//     input: process.stdin,
//     output: process.stdout
// });

// readline.question("Enter the primer: ", gstring => {
    // console.log(`Input accepted as ${gstring}. Calculating...\n`)
//     readline.close();
// });

// const prompt = require('prompt-sync')();
// const gstring = prompt(`Enter the primer: `);

// var crypto = require('crypto');
// var hash = crypto.createHash('sha256');
// hash.update("Enter the primer: ", 'utf-8');
// generated_hash = hash.digest('hex');
// console.log(generated_hash);

// const readline = require('readline-sync');
// let a = Number(readline.question());
// let number = [];
// for (let i = 0; i < a; ++i) {
//     number.push((readline.question()));
// };
// console.log(number);

// const readline = require('readline-sync');
// console.log("Enter the primer: ");
// let gstring = readline.question();
// let n = 13;
// mstring = gstring + String(n);
// console.log("Your string was:" + mstring);

const readline = require('readline-sync');
console.log("Enter the primer: ");
let gstring = readline.question();
console.log("Your string is " + gstring);
gstring = gstring.replace(/\n/g, '');
console.log("Your modified string is " + gstring + " removed \\n");


var crypto = require('crypto');
var hash = crypto.createHash('sha256');
// hash.update(gstring+String(1), 'utf-8');
hash.update(gstring, 'utf-8');
generated_hash = hash.digest('hex');

console.log("Original hash: " + generated_hash.toString('hex'));
console.log(typeof(generated_hash));
let num = 0;
// while(generated_hash >= 0x00000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
{
    num = num + 1;
    // hash.update(gstring+String(num), 'utf-8');
    // generated_hash = hash.digest();
}
console.log(gstring+String(num));
console.log(generated_hash);

var crypto = require('crypto');
var hash = crypto.createHash('sha256');

hash.update("a",'ascii');
mhash = hash.digest('hex');
console.log(mhash);
// a == ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb
// b == 3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d
hash = null;

var hash = crypto.createHash('sha256');
hash.update("b", "ascii");
mhash = hash.digest('hex');
console.log(mhash);