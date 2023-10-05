local get_os_name = require("utils.get_os_name").get_os_name

local M = {}

function M.delimiter()
   if get_os_name() == "Windows" then
      return "\\"
   else
      return "/"
   end
end

return M
