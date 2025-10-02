---@class jswent.colorscripts
local M = {}

M.random = function()
  local scripts = {}
  for k, v in pairs(M) do
    if k ~= "random" and type(v) == "table" and not v.disabled then
      scripts[k] = v
    end
  end
  local keys = {}
  for k in pairs(scripts) do
    table.insert(keys, k)
  end
  return scripts[keys[math.random(#keys)]]
end

-- Colorscripts

M.square = {
  cmd = [[
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
  height = 6,
  padding = 1,
}

M.pacman = {
  cmd = [[
f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'
inv=$'\e[7m'

cat << EOF

$rst
 $f3  ▄███████▄                $f1  ▄██████▄    $f2  ▄██████▄    $f4  ▄██████▄    $f5  ▄██████▄    $f6  ▄██████▄    
 $f3▄█████████▀▀               $f1▄$f7█▀█$f1██$f7█▀█$f1██▄  $f2▄█$f7███$f2██$f7███$f2█▄  $f4▄█$f7███$f4██$f7███$f4█▄  $f5▄█$f7███$f5██$f7███$f5█▄  $f6▄██$f7█▀█$f6██$f7█▀█$f6▄
 $f3███████▀      $f7▄▄  ▄▄  ▄▄   $f1█$f7▄▄█$f1██$f7▄▄█$f1███  $f2██$f7█ █$f2██$f7█ █$f2██  $f4██$f7█ █$f4██$f7█ █$f4██  $f5██$f7█ █$f5██$f7█ █$f5██  $f6███$f7█▄▄$f6██$f7█▄▄$f6█
 $f3███████▄      $f7▀▀  ▀▀  ▀▀   $f1████████████  $f2████████████  $f4████████████  $f5████████████  $f6████████████  
 $f3▀█████████▄▄               $f1██▀██▀▀██▀██  $f2██▀██▀▀██▀██  $f4██▀██▀▀██▀██  $f5██▀██▀▀██▀██  $f6██▀██▀▀██▀██
 $f3  ▀███████▀                $f1▀   ▀  ▀   ▀  $f2▀   ▀  ▀   ▀  $f4▀   ▀  ▀   ▀  $f5▀   ▀  ▀   ▀  $f6▀   ▀  ▀   ▀ 
$rst

EOF
]],
  height = 8,
  padding = 1,
  disabled = true,
}

M.panes = {
  cmd = [[
f=3 b=4
for j in f b; do
  for i in {0..7}; do
    eval "printf -v ${j}${i} %b '\e[${(P)j}${i}m'"
  done
done
d=$'\e[1m'
t=$'\e[0m'
v=$'\e[7m'
 
 
cat << EOF
 
  $f1███$d▄$t    $f2███$d▄$t    $f3███$d▄$t    $f4███$d▄$t    $f5███$d▄$t    $f6███$d▄$t    $f7███$d▄$t  
  $f1███$d█$t    $f2███$d█$t    $f3███$d█$t    $f4███$d█$t    $f5███$d█$t    $f6███$d█$t    $f7███$d█$t  
  $f1███$d█$t    $f2███$d█$t    $f3███$d█$t    $f4███$d█$t    $f5███$d█$t    $f6███$d█$t    $f7███$d█$t  
  $d$f1 ▀▀▀     $f2▀▀▀     $f3▀▀▀     $f4▀▀▀     $f5▀▀▀     $f6▀▀▀     $f7▀▀▀  
EOF
]],
  height = 6,
  padding = 1,
  -- disabled = true
}

M.rupees = {
  cmd = [[
initializeANSI()
{
  esc=""

  Bf="${esc}[30m";   rf="${esc}[31m";    gf="${esc}[32m"
  yf="${esc}[33m"   bf="${esc}[34m";   pf="${esc}[35m"
  cf="${esc}[36m";    wf="${esc}[37m"
  
  Bb="${esc}[40m";   rb="${esc}[41m";    gb="${esc}[42m"
  yb="${esc}[43m"   bb="${esc}[44m";   pb="${esc}[45m"
  cb="${esc}[46m";    wb="${esc}[47m"

  ON="${esc}[1m";    OFF="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeANSI

cat << EOF

                       ${Bf}██                               ${Bf}████                    ${Bf}████                    ${Bf}████                    ${Bf}████                    ${Bf}████
                     ${Bf}██${yf}██${Bf}██                           ${Bf}██${gf}${ON}██${OFF}██${Bf}██                ${Bf}██${bf}${ON}██${OFF}██${Bf}██                ${Bf}██${rf}${ON}██${OFF}██${Bf}██                ${Bf}██${pf}${ON}██${OFF}██${Bf}██                ${Bf}██${cf}${ON}██${OFF}██${Bf}██
                   ${Bf}██${yf}██████${Bf}██                       ${Bf}██${gf}${ON}████${OFF}████${Bf}██            ${Bf}██${bf}${ON}████${OFF}████${Bf}██            ${Bf}██${rf}${ON}████${OFF}████${Bf}██            ${Bf}██${pf}${ON}████${OFF}████${Bf}██            ${Bf}██${cf}${ON}████${OFF}████${Bf}██
                   ${Bf}██${yf}${ON}██${OFF}████${Bf}██                     ${Bf}██${gf}${ON}██████${OFF}██████${Bf}██        ${Bf}██${bf}${ON}██████${OFF}██████${Bf}██        ${Bf}██${rf}${ON}██████${OFF}██████${Bf}██        ${Bf}██${pf}${ON}██████${OFF}██████${Bf}██        ${Bf}██${cf}${ON}██████${OFF}██████${Bf}██
                 ${Bf}██${yf}██${ON}████${OFF}████${Bf}██                 ${Bf}██${gf}${ON}██${OFF}██${ON}██${OFF}██${Bf}██${gf}██${Bf}██${gf}██${Bf}██    ${Bf}██${bf}${ON}██${OFF}██${ON}██${OFF}██${Bf}██${bf}██${Bf}██${bf}██${Bf}██    ${Bf}██${rf}${ON}██${OFF}██${ON}██${OFF}██${Bf}██${rf}██${Bf}██${rf}██${Bf}██    ${Bf}██${pf}${ON}██${OFF}██${ON}██${OFF}██${Bf}██${pf}██${Bf}██${pf}██${Bf}██    ${Bf}██${cf}${ON}██${OFF}██${ON}██${OFF}██${Bf}██${cf}██${Bf}██${cf}██${Bf}██
                 ${Bf}██${yf}████${ON}██${OFF}████${Bf}██                 ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██
               ${Bf}██${yf}██████${ON}████${OFF}████${Bf}██               ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██
               ${Bf}██${yf}████████${ON}██${OFF}████${Bf}██               ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██
             ${Bf}██████████████████████             ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██
           ${Bf}██${yf}██${Bf}██              ██${yf}██${Bf}██           ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██
         ${Bf}██${yf}██████${Bf}██          ██${yf}██████${Bf}██         ${Bf}██${gf}${ON}████${OFF}██████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}████${OFF}██████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}████${OFF}██████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}████${OFF}██████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}████${OFF}██████${Bf}██${cf}████${Bf}██   
         ${Bf}██${yf}██████${Bf}██          ██${yf}${ON}██${OFF}████${Bf}██         ${Bf}██${gf}${ON}██${OFF}██${ON}██${OFF}████${Bf}██${gf}████${Bf}██    ${Bf}██${bf}${ON}██${OFF}██${ON}██${OFF}████${Bf}██${bf}████${Bf}██    ${Bf}██${rf}${ON}██${OFF}██${ON}██${OFF}████${Bf}██${rf}████${Bf}██    ${Bf}██${pf}${ON}██${OFF}██${ON}██${OFF}████${Bf}██${pf}████${Bf}██    ${Bf}██${cf}${ON}██${OFF}██${ON}██${OFF}████${Bf}██${cf}████${Bf}██
       ${Bf}██${yf}██████████${Bf}██      ██${yf}██${ON}████${OFF}████${Bf}██       ${Bf}██${gf}██████${ON}██${OFF}${Bf}██${gf}██${Bf}██${gf}██${Bf}██    ${Bf}██${bf}██████${ON}██${OFF}${Bf}██${bf}██${Bf}██${bf}██${Bf}██    ${Bf}██${rf}██████${ON}██${OFF}${Bf}██${rf}██${Bf}██${rf}██${Bf}██    ${Bf}██${pf}██████${ON}██${OFF}${Bf}██${pf}██${Bf}██${pf}██${Bf}██    ${Bf}██${cf}██████${ON}██${OFF}${Bf}██${cf}██${Bf}██${cf}██${Bf}██
       ${Bf}██${yf}${ON}██${OFF}████████${Bf}██      ██${yf}████${ON}██${OFF}████${Bf}██         ${Bf}██${gf}████████████${Bf}██        ${Bf}██${bf}████████████${Bf}██        ${Bf}██${rf}████████████${Bf}██        ${Bf}██${pf}████████████${Bf}██        ${Bf}██${cf}████████████${Bf}██
     ${Bf}██${yf}██${ON}████${OFF}████████${Bf}██  ██${yf}██████${ON}████${OFF}████${Bf}██         ${Bf}██${gf}████████${Bf}██            ${Bf}██${bf}████████${Bf}██            ${Bf}██${rf}████████${Bf}██            ${Bf}██${pf}████████${Bf}██            ${Bf}██${cf}████████${Bf}██
     ${Bf}██${yf}████${ON}██${OFF}████████${Bf}██  ██${yf}████████${ON}██${OFF}████${Bf}██           ${Bf}██${gf}████${Bf}██                ${Bf}██${bf}████${Bf}██                ${Bf}██${rf}████${Bf}██                ${Bf}██${pf}████${Bf}██                ${Bf}██${cf}████${Bf}██
     ${Bf}██████████████████████████████████████             ${Bf}████                    ${Bf}████                    ${Bf}████                    ${Bf}████                    ${Bf}████${reset}

EOF
]],
  height = 15,
  padding = 2,
  disabled = true,
}

M.thebat = {
  cmd = [[
initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

# note in this first use that switching colors doesn't require a reset
# first - the new color overrides the old one.

clear
initializeANSI

cat << EOF

 ${redf} ▄█▀ █ █ ▀█▄   ${greenf} ▄█▀ █ █ ▀█▄   ${yellowf} ▄█▀ █ █ ▀█▄   ${bluef} ▄█▀ █ █ ▀█▄   ${purplef} ▄█▀ █ █ ▀█▄   ${cyanf} ▄█▀ █ █ ▀█▄ 
 ${redf}███  ███  ███  ${greenf}███  ███  ███  ${yellowf}███  ███  ███  ${bluef}███  ███  ███  ${purplef}███  ███  ███  ${cyanf}███  ███  ███
 ${redf}█████████████  ${greenf}█████████████  ${yellowf}█████████████  ${bluef}█████████████  ${purplef}█████████████  ${cyanf}█████████████
 ${redf} ▀██▄   ▄██▀   ${greenf} ▀██▄   ▄██▀   ${yellowf} ▀██▄   ▄██▀   ${bluef} ▀██▄   ▄██▀   ${purplef} ▀██▄   ▄██▀   ${cyanf} ▀██▄   ▄██▀ 
${reset} 
EOF
]],
  height = 6,
  padding = 1,
  disabled = true,
}

M.tiefighter = {
  cmd = [[
initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeANSI

cat << EOF
${redf}  ▄▄     ▄▄    ${greenf}  ▄▄     ▄▄    ${yellowf}  ▄▄     ▄▄    ${bluef}  ▄▄     ▄▄    ${purplef}  ▄▄     ▄▄    ${cyanf}   ▄▄     ▄▄   
${redf}▄█▀  ▄▄▄  ▀█▄  ${greenf}▄█▀  ▄▄▄  ▀█▄  ${yellowf}▄█▀  ▄▄▄  ▀█▄  ${bluef}▄█▀  ▄▄▄  ▀█▄  ${purplef}▄█▀  ▄▄▄  ▀█▄  ${cyanf} ▄█▀  ▄▄▄  ▀█▄ 
${redf}██▄▄██▀██▄▄██  ${greenf}██▄▄██▀██▄▄██  ${yellowf}██▄▄██▀██▄▄██  ${bluef}██▄▄██▀██▄▄██  ${purplef}██▄▄██▀██▄▄██  ${cyanf} ██▄▄██▀██▄▄██ 
${redf}██▀▀█████▀▀██  ${greenf}██▀▀█████▀▀██  ${yellowf}██▀▀█████▀▀██  ${bluef}██▀▀█████▀▀██  ${purplef}██▀▀█████▀▀██  ${cyanf} ██▀▀█████▀▀██ 
${redf}▀█▄  ▀▀▀  ▄█▀  ${greenf}▀█▄  ▀▀▀  ▄█▀  ${yellowf}▀█▄  ▀▀▀  ▄█▀  ${bluef}▀█▄  ▀▀▀  ▄█▀  ${purplef}▀█▄  ▀▀▀  ▄█▀  ${cyanf} ▀█▄  ▀▀▀  ▄█▀ 
${redf}  ▀▀     ▀▀    ${greenf}  ▀▀     ▀▀    ${yellowf}  ▀▀     ▀▀    ${bluef}  ▀▀     ▀▀    ${purplef}  ▀▀     ▀▀    ${cyanf}   ▀▀     ▀▀   
${reset}

EOF
]],
  height = 7,
  padding = 1,
  disabled = true,
}

return M
