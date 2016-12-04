// How the terminal works.

// First, we require a parser for Javascript, called esprima. It allows my code
// to understand what is entered in as data - meaning that it can figure out
// where to find values & the like.
const esprima = require('esprima');

// Then, we'll install escodegen, which allows us to re-generate code that was
// parsed, so that our code can make additions before entered code is run.
const escodegen = require('escodegen');

// Next, we'll create a sample user-entered program to parse.
const program =
  'const answer = 42; var test = "foo";' +
  'this.foo = "bar";' +
  'function test(){console.log(answer)}';

// Here's the cool(ish) part: We parse the user-generated program. Magically,
// it spits back a data structure that is more easy to work with.
const parsedProgram = esprima.parse(program);

// Next, I want to access the variables in the program. In order to do so,
// I need to know which variables are specified, and where they are. We'll look
// for VariableDeclarations (created when Javascript sees the `var` keyword).

// We're going to create a function to get the variable declarations in an
// element of code. It accepts 2 arguments, parsedEl (for the parsed element),
// and cb, for a callback. The callback is executed whenever it finds a
// variable decloration, allowing the code to run faster (instead of interating
// multiple times - once to find declarations and once to deal with them,
// it only does so once, making the resulting sequence ~2x faster.
//
// Other then the callback, this function returns an array of variable
// declensions.
//
// The callback function should return the element it was passed, as the return
// value replaces the element in the resulting array.
const getVariableDeclations = function(parsedEl, cb){
  // First, we need to create a recursiveVarFinder by calling the function. It
  // will generate a new function that has a callback loaded. Then, we can use
  // rvf instead of using recursiveVarFinder.
  const rvf = recursiveVarFinder(cb);
  // If the function has a body that is an array...
  if(Array.isArray(parsedEl.body))
    // reduce it, and return the result.
    return parsedEl.body.reduce(recursiveVarFinder(cb), []);
    // otherwise, return an empty array.
  else return [];
};

// Then, we create a function for reducing element bodies into declensions.
// Because it needs a callback, and I want to make it work in any context and
// let it work easily with reduce, I'm going to wrap it with a function that
// takes a single argument - cb - and returns the function with cb in it's
// context. Confusing - but it works :P
//
// We'll also accept a el element, and if it is passed, we'll jump into running
// the function with a default callback.
const recursiveVarFinder = function(cb, el){
  // If el was passed to this function, we need to jump to running the function.
  // We'll set cb to it's default value.
  cb = function(d){return d};

  // We'll set a default callback function if one wasn't passed to this
  // function. It just returns the argument, in order to make the array return a
  // list of varible declations by default.
  cb || (cb = function(d){return d});

  // Then, we create the function.
  const rvf = function(decl, el){
    // If it's a variable declension, and not another type of element...
    if(el.type === 'VariableDeclaration')
      // concatinate (merge lists) the current list of variable declartions, and
      // return, stopping the rest of the function from continueing, and starting
      // the function over with the next element and the returned decl value.
      return decl.concat([cb(el)]);
    if(Array.isArray(el.body))
      return el.body.reduce(recursiveVarFinder, decl);
  };

  if(el){
    return rvf(cb, el);
  }
}

const foundDeclaration = function(declEl){
  console.log('Found: ', declEl.declarations.map(function(d){return d.id}));
  return escodegen.generate(declEl);
};

// This returns all variable declarations.
const variables = getVariableDeclations(parsedProgram, foundDeclaration);
