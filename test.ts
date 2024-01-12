// comments are written with two '/' characters

// variables can be declared constant, making them unmodifiable
const x = 5
// or mutatable with let
let y = 2

// enumerable types are declared as follows, they are called tags
const Day = 
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday


// functions must be const
const next_day = fn(d:Day) Day {
 // enumerable types can be matched on
 return match d {
  .monday => tuesday
  .tuesday => wednesday
 }
}

// syntax on returns are not decided

// struct syntax
const Car = struct {
  wheels: f64
  make: [char]
  model: [char]
  direction: u8
}

// you can attach functions to structs
const drive = fn(self: Car, direction: u8) void {
  self.direction = direction
}


// arrays can be sized and length is unknown
// here x is immutable, so the compiler can give it size 11
// the elements inside x can be mutated
const x: [char] = "Hello There"
// here x is immutable, and the elements inside the array are immutable
const x: [const char] = "Hello There"

// here y is mutable, meaning the array can be lengthend or shortened. this will not compile, as explicitly sized arrays, can't be resized
let y: [char; 11] = "Hello There"

// here y is mutable, and its elements are mutable. can be lengthened or shortened
let y: [char] = "Hello There"

// values can be copied, moved, borrowed mutably, or borrowed immutably
// x is set to 5
const x = 5
// x is copied. All primative scalar types are copied
const y = x
// m is moved to z, m is no longer reachable after z has been assigned
let m = "Hello There"
let z = m
print(m)

// count_spaces takes a read-only borrowed slice of an array of known or unknown length. & is a read-only borrow, and * is a mutable borrowx
// note: do not think of these as pointers
// to_check is read only slice with read only chars
const count_spaces = fn(to_check: &[&char]) f64 {
  let count = 0
  for (to_check) |x| {
    if (x == ' ') {
      count += 1
    }
  }
  return count
}

// you can pass a value by ownership
const count_spaces = fn(to_check: [char]) f64 { }

// how to do types, traits, aliasing, subtyping?

// reference self for 1 to 1 aliasing
type c_chars: const [const char] = self

// some types have a special way to subtype values
type months: u8 = 0..12

// prepare a type to be used as an implementation
type to_draw: fn(self) void = self

const rgba = struct {
  r: u8
  g: u8
  b: u8
  a: u8
}

impl rgba: to_draw = fn(self) void {
  // do some cool drawing
}

// errors are first class citizens
