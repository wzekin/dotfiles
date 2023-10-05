local wezterm = require("wezterm")
local path = require("utils.path")

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local GLYPH_SEMI_CIRCLE_LEFT = ""
-- local GLYPH_SEMI_CIRCLE_LEFT = utf8.char(0xe0b6)
local GLYPH_SEMI_CIRCLE_RIGHT = ""
-- local GLYPH_SEMI_CIRCLE_RIGHT = utf8.char(0xe0b4)
local GLYPH_CIRCLE = ""
-- local GLYPH_CIRCLE = utf8.char(0xf111)
local GLYPH_ADMIN = "ﱾ"
-- local GLYPH_ADMIN = utf8.char(0xfc7e)

local function basename(s)
   return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function convert_home_dir(dir)
   local cwd = dir
   local home = wezterm.home_dir
   cwd = cwd:gsub("^" .. home .. path.delimiter(), "~" .. path.delimiter())
   if cwd == "" then
      return path
   end
   return cwd
end

local function clear_dir(dir)
   local separator = path.delimiter()

   -- 删除多余的路径分隔符
   local cleanedPath = dir:gsub("[\\/]+", separator)

   local driveLetter = cleanedPath:match("^[A-Za-z]:")
   if driveLetter then
      cleanedPath = cleanedPath:sub(4)
   end

   local segments = {}
   for segment in cleanedPath:gmatch("[^" .. separator .. "]+") do
      table.insert(segments, segment)
   end

   local absoluteSegments = {}
   local segment_len = #segments
   for i, segment in ipairs(segments) do
      if segment == ".." then
         table.remove(absoluteSegments)
      elseif segment ~= "." then
         if i >= segment_len - 1 then
            table.insert(absoluteSegments, segment)
         else
            table.insert(absoluteSegments, segment:sub(1, 1))
         end
      end
   end

   local shortenedPath = table.concat(absoluteSegments, separator)

   return (driveLetter and driveLetter .. separator or "") .. shortenedPath
end

local M = {}

M.cells = {}

M.colors = {
   default = {
      bg = "#45475a",
      fg = "#1c1b19",
   },
   is_active = {
      bg = "#7FB4CA",
      fg = "#11111b",
   },

   hover = {
      bg = "#587d8c",
      fg = "#1c1b19",
   },
}

M.set_title = function(title, max_width, is_admin, has_unseen_output)
   local inset = 4
   if is_admin then
      inset = inset + 2
   end

   if has_unseen_output then
      inset = inset + 2
   end

   title = clear_dir(convert_home_dir(title))

   title = wezterm.truncate_right(title, max_width - inset)

   return title
end

M.check_if_admin = function(p)
   if p:match("^Administrator: ") then
      return true
   end
   return false
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
M.push = function(bg, fg, attribute, text)
   table.insert(M.cells, { Background = { Color = bg } })
   table.insert(M.cells, { Foreground = { Color = fg } })
   table.insert(M.cells, { Attribute = attribute })
   table.insert(M.cells, { Text = text })
end

local function tab_title(tab_info)
   local title = tab_info.tab_title
   -- if the tab title is explicitly set, take that
   if title and #title > 0 then
      return title
   end
   -- Otherwise, use the title from the active pane
   -- in that tab
   return tab_info.active_pane.title
end

M.setup = function()
   wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
      M.cells = {}

      local bg
      local fg
      local is_admin = M.check_if_admin(tab.active_pane.title)
      local has_unseen_output = false
      for _, pane in ipairs(tab.panes) do
         if pane.has_unseen_output then
            has_unseen_output = true
            break
         end
      end
      local title = M.set_title(tab_title(tab), max_width, is_admin, has_unseen_output)

      if tab.is_active then
         bg = M.colors.is_active.bg
         fg = M.colors.is_active.fg
      elseif hover then
         bg = M.colors.hover.bg
         fg = M.colors.hover.fg
      else
         bg = M.colors.default.bg
         fg = M.colors.default.fg
      end

      -- Left semi-circle
      M.push(fg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_LEFT)

      -- Admin Icon
      if is_admin then
         M.push(bg, fg, { Intensity = "Bold" }, " " .. GLYPH_ADMIN)
      end

      -- Title
      M.push(bg, fg, { Intensity = "Bold" }, " " .. title)

      -- Unseen output alert
      if has_unseen_output then
         M.push(bg, "#FFA066", { Intensity = "Bold" }, " " .. GLYPH_CIRCLE)
      end

      -- Right padding
      M.push(bg, fg, { Intensity = "Bold" }, " ")

      -- Right semi-circle
      M.push(fg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_RIGHT)

      return M.cells
   end)
end

return M

-- -- local CMD_ICON = utf8.char(0xe62a)
-- -- local NU_ICON = utf8.char(0xe7a8)
-- -- local PS_ICON = utf8.char(0xe70f)
-- -- local ELV_ICON = utf8.char(0xfc6f)
-- -- local WSL_ICON = utf8.char(0xf83c)
-- -- local YORI_ICON = utf8.char(0xf1d4)
-- -- local NYA_ICON = utf8.char(0xf61a)
-- --
-- -- local VIM_ICON = utf8.char(0xe62b)
-- -- local PAGER_ICON = utf8.char(0xf718)
-- -- local FUZZY_ICON = utf8.char(0xf0b0)
-- -- local HOURGLASS_ICON = utf8.char(0xf252)
-- -- local SUNGLASS_ICON = utf8.char(0xf9df)
-- --
-- -- local PYTHON_ICON = utf8.char(0xf820)
-- -- local NODE_ICON = utf8.char(0xe74e)
-- -- local DENO_ICON = utf8.char(0xe628)
-- -- local LAMBDA_ICON = utf8.char(0xfb26)
-- --
-- -- local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
-- -- local SOLID_LEFT_MOST = utf8.char(0x2588)
-- -- local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)
-- -- local ADMIN_ICON = utf8.char(0xf49c)

-- ---------------------------------------------------------------
-- --- wezterm on
-- ---------------------------------------------------------------
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

--    -- selene: allow(undefined_variable)
--    local solid_left_arrow = utf8.char(0x2590)
--    -- selene: allow(undefined_variable)
--    local solid_right_arrow = utf8.char(0x258c)
--    -- https://github.com/wez/wezterm/issues/807
--    -- local edge_background = scheme.background
--    -- https://github.com/wez/wezterm/blob/61f01f6ed75a04d40af9ea49aa0afe91f08cb6bd/config/src/color.rs#L245
--    local edge_background = "#2e3440"
--    local background = scheme.ansi[1]
--    local foreground = scheme.ansi[5]

--    if tab.is_active then
--       background = scheme.brights[1]
--       foreground = scheme.brights[8]
--    elseif hover then
--       background = scheme.cursor_bg
--       foreground = scheme.cursor_fg
--    end
--    local edge_foreground = background

--    return {
--       { Attribute = { Intensity = "Bold" } },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = solid_left_arrow },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = solid_right_arrow },
--       { Attribute = { Intensity = "Normal" } },
--    }
-- end)
