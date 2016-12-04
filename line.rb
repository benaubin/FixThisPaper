require 'io/console'

Coords = Struct.new(:x,:y)

#line = Coords.new(0,0)

arrows = {
  "A": :up,
  "D": :left, "C": :right,
  "B": :down
}

loop do
  if "\e" == STDIN.raw(&:getc) && "[" == STDIN.raw(&:getc)
    c = STDIN.raw(&:getc)
    p c
    p arrows[c].to_s
  end
  sleep 0.1
end
