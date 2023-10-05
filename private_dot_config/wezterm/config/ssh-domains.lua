local wezterm = require("wezterm")

local ssh_domains = {}

for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
   table.insert(ssh_domains, {
      name = host,
      remote_address = config.hostname,
      -- multiplexing = "None",
      assume_shell = "Posix",
      default_prog = { "zsh" },
   })
end

return ssh_domains
