local M = {}

vim.cmd([[
  function Test()
    %SnipRun
    call feedkeys("\<esc>`.")
  endfunction

  function TestI()
    let b:caret = winsaveview()    
    %SnipRun
    call winrestview(b:caret)
  endfunction
]])

function M.sniprun_enable()
  vim.cmd([[
    %SnipRun

    augroup _sniprun
     autocmd!
     autocmd TextChanged * call Test()
     autocmd TextChangedI * call TestI()
    augroup end
  ]])
  vim.notify("Enabled SnipRun")
end

function M.disable_sniprun()
  M.remove_augroup("_sniprun")
  vim.cmd([[
    SnipClose
    SnipTerminate
    ]])
  vim.notify("Disabled SnipRun")
end

function M.toggle_sniprun()
  if vim.fn.exists("#_sniprun#TextChanged") == 0 then
    M.sniprun_enable()
  else
    M.disable_sniprun()
  end
end

function M.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

vim.cmd([[ command! SnipRunToggle execute 'lua require("jswent.functions").toggle_sniprun()' ]])

-- get length of current word
function M.get_word_length()
  local word = vim.fn.expand("<cword>")
  return #word
end

function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
  local value = vim.api.nvim_get_option_value("showtabline", {})

  if value == 2 then
    value = 0
  else
    value = 2
  end

  vim.opt.showtabline = value

  vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

local virtualtext_active = true
function M.toggle_virtualtext()
  virtualtext_active = not virtualtext_active
  if virtualtext_active then
    vim.diagnostic.config({ virtual_text = true })
  else
    vim.diagnostic.config({ virtual_text = false })
  end
end

function M.isempty(s)
  return s == nil or s == ""
end

function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

function M.smart_quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd("q!")
      end
    end)
  else
    vim.cmd("q!")
  end
end

function M.is_plugin_loaded(plugin_name)
  local plugin = vim.tbl_get(require("lazy.core.config"), "plugins", plugin_name)
  return plugin and plugin._.loaded and plugin._.loaded.start == "start" or false
end

M.colorscripts = {
  square = [[
  initializeANSI() {
  esc=""

  blackf="${esc}[30m"
  redf="${esc}[31m"
  greenf="${esc}[32m"
  yellowf="${esc}[33m" bluef="${esc}[34m"
  purplef="${esc}[35m"
  cyanf="${esc}[36m"
  whitef="${esc}[37m"

  blackb="${esc}[40m"
  redb="${esc}[41m"
  greenb="${esc}[42m"
  yellowb="${esc}[43m" blueb="${esc}[44m"
  purpleb="${esc}[45m"
  cyanb="${esc}[46m"
  whiteb="${esc}[47m"

  boldon="${esc}[1m"
  boldoff="${esc}[22m"
  italicson="${esc}[3m"
  italicsoff="${esc}[23m"
  ulon="${esc}[4m"
  uloff="${esc}[24m"
  invon="${esc}[7m"
  invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeANSI

cat <<EOF

 ${redf}▀ █${reset} ${boldon}${redf}█ ▀${reset}   ${greenf}▀ █${reset} ${boldon}${greenf}█ ▀${reset}   ${yellowf}▀ █${reset} ${boldon}${yellowf}█ ▀${reset}   ${bluef}▀ █${reset} ${boldon}${bluef}█ ▀${reset}   ${purplef}▀ █${reset} ${boldon}${purplef}█ ▀${reset}   ${cyanf}▀ █${reset} ${boldon}${cyanf}█ ▀${reset} 
 ${redf}██${reset}  ${boldon}${redf} ██${reset}   ${greenf}██${reset}   ${boldon}${greenf}██${reset}   ${yellowf}██${reset}   ${boldon}${yellowf}██${reset}   ${bluef}██${reset}   ${boldon}${bluef}██${reset}   ${purplef}██${reset}   ${boldon}${purplef}██${reset}   ${cyanf}██${reset}   ${boldon}${cyanf}██${reset}  
 ${redf}▄ █${reset}${boldon}${redf} █ ▄ ${reset}  ${greenf}▄ █ ${reset}${boldon}${greenf}█ ▄${reset}   ${yellowf}▄ █ ${reset}${boldon}${yellowf}█ ▄${reset}   ${bluef}▄ █ ${reset}${boldon}${bluef}█ ▄${reset}   ${purplef}▄ █ ${reset}${boldon}${purplef}█ ▄${reset}   ${cyanf}▄ █ ${reset}${boldon}${cyanf}█ ▄${reset}  

EOF
]],
}

return M
