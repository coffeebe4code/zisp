--- Ada
with Ada.Text_IO;

procedure Greet is
begin
   --  Print "Hello, World!" to the screen
   Ada.Text_IO.Put_Line ("Hello, World!");
end Greet;

--- Zada
with io = "std.io"

fn greet() {
  io.put_line("Hello, World")
}

--- Ada
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Check_Positive is
   N : Integer;
begin
   --  Put a String
   Put ("Enter an integer value: ");

   --  Read in an integer value
   Get (N);

   if N > 0 then
      --  Put an Integer
      Put (N);
      Put_Line (" is a positive number");
   end if;
end Check_Positive

--- Zada
with io = "std.io"

fn check_positive() {
  let n = 0
  io.put("Enter an integer value: ")
  io.get(&n)

  if n > 0 {
    io.put(&n)
    io.put_line(" is a positive number")
  }
}

--- Ada
with Ada.Text_IO; use Ada.Text_IO;

procedure Greet_5a is
begin
   for I in 1 .. 5 loop
      --  Put_Line is a procedure call
      Put_Line ("Hello, World!"
                  & Integer'Image (I));
      --        ^ Procedure parameter
   end loop;
end Greet_5a;

--- Zada
with io = "std.io"

fn greet_5a {
  for i in 1..5 {
    io.put_line("Hello, World! {}", i) 
  }
}

type Day = 1..31
type Month = 1..12
type Year = 0..2200

type Weekday = enum {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

type Date = struct {
  day   : Day,
  month : Month,
  year  : Year,
}

for 1..10 |i| {

}

if a > b {

}
else {

}


switch x {
  Response.OK => |val| print(val.to_string()),
}
  
