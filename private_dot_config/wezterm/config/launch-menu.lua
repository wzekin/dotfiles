local get_os_name = require("utils.get_os_name")

local launch_menu = {}

if get_os_name.get_os_name() == "Windows" then
   launch_menu = {
      -- { label = "Ubuntu", args = { "wsl", "-d", "Ubuntu" }, domain = { DomainName = "ubuntu" } },
      {
         label = "PowerShell Core",
         args = { "pwsh" },
      },
      {
         label = "Command Prompt",
         args = { "cmd" },
      },
      {
         label = "Nushell",
         args = { "nu" },
      },
      {
         label = "PowerShell Desktop",
         args = { "powershell" },
      },
   }
else
   launch_menu = {
      { label = "zsh", args = { "/usr/bin/zsh" } },
   }
end

return launch_menu
