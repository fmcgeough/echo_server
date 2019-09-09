defmodule EchoServer.EchoID do
  @moduledoc """
  Generates an id that can be used as primary key

  We're using safe32 for the charset. This produces Strings that don't look
  like English words and are easy to parse visually. The Strings exclude:
  1) Upper and lower case vowels (including y); 2) numbers that look like
  letters; 3) letters that look like numbers; 4) letters that have poor
  distinction between upper and lower case values.

  The String length is 16. This ends up using the same db space as a
  Postgres uuid.

  ## Example IDs
  ["N7Q3rhNJjNPnR9jh", "D624g3hP4gtMpbh2", "rjRgHjHgjNM4G3gp",
   "D3Q9gmN4BnbTf2P9", "63R3qMt2GT2jh94H", "b68M3fmdHqNF6PdR",
   "pDJQpbPLPrRJLQdB", "Q8q4PMHpr29gpqMp"]
  """
  use(Puid, total: 1.0e6, risk: 1.0e12, charset: :safe32)
end
