--
-- exact primes list from https://primes.utm.edu/lists/small/millions/primes1.zip

function read_content( path )
   local f = io.open( path, "r" )
   if f then
      local content = f:read("*a")
      f:close()
      return content
   end
   return nil
end

local content = read_content( ... )

for v in content:gmatch("%s+(%d+)") do
   print(v)
end
