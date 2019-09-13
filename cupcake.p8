pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--cupcake
-- a game for max from his dad

--global variables
--for game state
lvl=0
f_tick=0
s_tick=0
countdown=0
--entities that
--animate
e={}
--track button mashing
bmt=0
debug=false
score=0

function _init()
 cls()
 --start at lvl 0,
 -- the title screen
 lvl=0
 --play the intro music
 music(0, 660)
 --reset animation state
 f_tick=0
 s_tick=0
 ent={}
 menuitem(1, "toggle debug", toggle_debug)
end

function toggle_debug()
 if debug then
  debug=false
 else
  debug=true
 end
end

function _draw()
 cls()
 if lvl==0 then
  draw0()
 elseif lvl==0.5 then
  draw0_5()
 elseif lvl==1 then
  draw1()
 end
end

function _update()
 --animation
 f_tick=(f_tick+1)%30
 s_tick=(s_tick+1)%100

 if lvl==0 then
  update0()
 elseif lvl==0.5 then
  update0_5()
 elseif lvl==1 then
  update1()
 end
end

--draw the title screem
function draw0()
 --fill in the background
 rectfill(0,0,127,127,14)
 --draw the sprites for
 --the title
 draw0_title()
 --background for instruct
 rectfill(28,75, 98,89, 7)
 pset(29,76, 0)
 pset(97,76, 0)
 pset(29,88, 0)
 pset(97,88, 0)
 --draw instruct
 color(0)
 print('mash all buttons',32,80)
 --filigree
 filigree(0)
end

--draw the title
function draw0_title()
 --for each character
 for c=0,6 do
  local off=title_offset(s_tick,c)
  map(c*2,0, 8+(c*16),40+off, 2,2)
 end
end

function title_offset(s_tick,c)
 local off=cos(0.25+(s_tick*0.01)-(c*0.05))
 off=flr(off*5)
 if off==5 then
  off=4
 end
 return off
end

--draw pretty lines border
function filigree()
 local lines={}
 --large outside lines
 add(lines, {1,1, 1,20})
 add(lines, {1,1, 30,1})
 --first curl
 add(lines, {1,5, 3,5})
 add(lines, {3,5, 3,3})
 --second curl
 add(lines, {8,1, 8,5})
 add(lines, {8,5, 6,5})
 add(lines, {6,5, 6,3})
 --third curl
 add(lines, {1,8, 5,8})
 add(lines, {5,8, 5,10})
 add(lines, {3,8, 3,12})
 --fourth curl
 add(lines, {12,1, 12,5})
 add(lines, {12,5, 14,5})
 add(lines, {12,3, 16,3})
 --fifth curl
 add(lines, {23,1, 23,3})
 add(lines, {23,3, 22,3})

 for l in all(lines) do
 --top left
  line(l[1],l[2], l[3],l[4])
 --top right
  line(127-l[1],l[2], 127-l[3],l[4])
 --bottom left
  line(l[1],127-l[2], l[3],127-l[4])
 --bottom right
  line(127-l[1],127-l[2], 127-l[3],127-l[4])
 end
end

function update0()
 if btnp()>0 then
  music(-1, 660)
  countdown=20
  lvl=0.5
 end
end

function draw0_5()
 fade(20-countdown)
 draw0()
end

function update0_5()
 countdown=countdown-1
 if countdown<=0 then
  music(1)
  lvl=1
  pal()
  cls()
  --flour scoop
  add(e,{st={{64,4,2},
             {32,4,2},
             {96,4,2},
             {96,4,2},
             {36,4,2},
             {36,4,2}},
             cps={{5,110},
                  {5,-50},
                  {85,-50},
                  {84,180},
                  {84,180},
                  {85,-50},
                  {5,-50},
                  {5,110}},
             t=0,
             v=0,
             sc=false,
             w=1000})
  --baking powder scoop
  add(e,{st={{44,2,1},
             {58,2,1},
             {60,2,1},
             {60,2,1},
             {42,2,1},
             {42,2,1}},
             cps={{39,112},
                  {39,0},
                  {95,0},
                  {92,150},
                  {92,150},
                  {95,0},
                  {39,0},
                  {39,112}},
             t=0,
             v=0,
             sc=false,
             w=500})
  --cocoa scoop
  add(e,{st={{132,2,1},
             {146,2,1},
             {148,2,1},
             {148,2,1},
             {130,2,1},
             {130,2,1}},
             cps={{57,112},
                  {57,-30},
                  {100,-30},
                  {100,170},
                  {100,170},
                  {100,-30},
                  {57,-30},
                  {57,112}},
             t=0,
             v=0,
             sc=false,
             w=600})
 end
end

--draw the first lvl
function draw1()
 --fill in the background
 map(0,2, 0,0, 16,16)
 --bowl
 spr(72, 55,75, 8,5)
 --step
 rectfill(57,1, 126,15, 7)
 pset(58,2, 0)
 pset(125,2, 0)
 pset(125,14, 0)
 pset(58,14, 0)
 color(0)
 print('dry ingredients',63,6)
 --animate entities
 for _, ent in pairs(e) do
  drawent(ent)
 end
 --front of bowl
 palt(5,true)
 spr(88, 55,83, 8,4)
 palt()
 --flour
 spr(68, 4,95, 4,4)
 --baking powder
 spr(46, 38,111, 2,2)
 --cocoa
 spr(128, 56,111, 2,2)
end

function update1()
 local bm = wasbm()
 for i, ent in pairs(e) do
  path(ent, bm)
 end
end

function drawent(ent)
 local step=1/#ent.st
 local s=1
 for i=1,#ent.st do
  if ent.t>=(step*i) then
   s=i
  end
 end
 espr = ent.st[s]
 local x,y = calxy(ent.cps,ent.t)
 spr(espr[1],
     x,y,
     espr[2],espr[3])
 if debug then
  print('',0,0)
  print('t:'..ent.t..' v:'..ent.v)
  print('fo:'..(1/ent.w))
  print('fr:'..((1/ent.w)*0.8))
  print('s:'..s)
  for i, cp in pairs(ent.cps) do
   pset(cp[1],cp[2],11)
  end
  for i=0,1,0.01 do
   local x,y = calxy(ent.cps,i)
   pset(x,y,1)
  end
 end
end

function path(ent, bm)
 if bm then
  ent.v+=(1/ent.w)
 else
  ent.v=max(
   (ent.v-((1/ent.w)*0.8))
   ,0)
 end
 if (ent.t>0.5) and ent.sc==false then
  score+=1
  ent.sc=true
 end
 if (ent.t+ent.v)>1 then
  ent.t=0
  ent.sc=false
 end
 ent.t+=ent.v
end

function wasbm()
 local bs = btn()
 if bs!=bmt then
  bmt=bs
  return true
 end
 return false
end

--'library' code
--davbo bezier curves
--https://www.lexaloffle.com/bbs/?tid=30044
function calxy(cps,t)
 local x,y=0,0
 cpno=#cps
 for i=0,cpno-1 do
  x+=dfor(i,1,cps,cpno,t)
  y+=dfor(i,2,cps,cpno,t)
 end
 return x,y
end

function dfor(i,c,cps,cpno,t)
 dc=binomial(cpno-1,i)
 dc*=(1-t)^((cpno-1)-i)
 dc*=t^i
 dc*=cps[i+1][c]
 return dc
end

function binomial(n,k)
 if k>n then return nil end
 if k>n/2 then k = n-k end
 local numer, denom = 1, 1
 for i=1,k do
  numer = numer * (n-i+1)
  denom = denom * i
 end
 return numer / denom
end

--kometbomb fades
--https://www.lexaloffle.com/bbs/?tid=28552
-- 20 frame fades
local fadetable={
 {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0},
 {2,2,2,2,2,2,2,1,1,1,1,1,0,0,0,0,0,0,0},
 {3,3,3,3,3,3,3,1,1,1,1,1,0,0,0,0,0,0,0},
 {4,4,4,4,2,2,2,2,2,2,1,1,0,0,0,0,0,0,0},
 {5,5,5,5,5,5,1,1,1,1,1,1,0,0,0,0,0,0,0},
 {6,6,6,13,13,13,13,13,5,5,5,5,5,1,1,1,0,0,0},
 {7,7,6,6,6,6,13,13,13,13,5,5,5,5,1,1,1,0,0},
 {8,8,8,8,8,2,2,2,2,2,2,2,2,0,0,0,0,0,0},
 {9,9,9,9,4,4,4,4,4,4,4,5,5,5,0,0,0,0,0},
 {10,10,10,9,9,9,4,4,4,4,5,5,5,5,5,0,0,0,0},
 {11,11,11,11,3,3,3,3,3,3,3,3,1,0,0,0,0,0,0},
 {12,12,12,12,12,12,3,3,3,1,1,1,1,1,1,1,0,0,0},
 {13,13,13,13,5,5,5,5,5,1,1,1,1,1,1,0,0,0,0},
 {14,14,14,14,13,4,4,2,2,2,2,2,2,1,1,1,0,0,0},
 {15,15,15,6,13,13,13,13,5,5,5,5,5,5,1,1,0,0,0}
}

function fade(i)
 for c=0,15 do
  if flr(i+1)>=20 then
   pal(c,0)
  else
   pal(c,fadetable[c+1][flr(i+1)])
  end
 end
end
__gfx__
00000000007777777777770079999700000077700079999700000000000000000077777779999970777777000799999700077777777770000779999779999770
00000000077777777777777079999770000799970779999700077770077770000777777779999997777777707999999700777777777777007799999779999977
00000000777777777777777779999977777799977799999700777777777777007777777779999999777777779999997707777777777777709999999779999999
00000000799799799999979779999999999999979999999700777777777777007979999979999999997997979999977077979999999979779999999779999999
00000000799999999999999774949494949494979494949700799797779997007979999979494947999997977777770079999977779979974949494774949494
00000000799999777777999774444444444444474444444700799997799997007999997774444447779997970000000079999770077979977744444774444477
00000000799997700007999777444444444444474444444700799997799997007999977074444447077999970000000079999700007999970774444774444770
00000000799997000000777007777777777777707777777000799997799997007999970007777770007999970000000079999700007999970077777007777700
00777700000777007999999999997700007777777777000079999999999999706666666666666666444444444545454555555555444444440000000000000000
07777770007777707999999999999770077777777777700079997777777799706fffffffffffffff544454445454545455555555444444440000000000000000
77777777077777777999999999999977777777777777770079997000000777706fffffffffffffff444444444544454455555555444444440000000000000000
79799797779999977999999779999997797999799999970079997777777777706fffffffffffffff444444445454545445554555444444440000000000000000
79799797799999977949494777949497797999999999970074949494949494976fffffffffffffff444444444444444454545454444444440000000000000000
79999799999999777444444707744447797997777777700074444444444444776fffffffffffffff444444444544544554545454444444440000000000000000
79999999999997707444444700774447799999999777770074444444444447706fffffffffffffff444444444444444445454545444444440000000000000000
79999999999977000777777000077770799999999999997007777777777777006fffffffffffffff444444445445445454545454444444440000000000000000
00000000000000000000000000000000000000000000000000000000000000006fffffffffffffff066666000000000006666600000000000aaaaaaaaaaaaaa0
00666666666666000000000000000000006666666666660000000000000000006fffffffffffffff66555660000000006677766000000000a44444444444444a
06677777777776600000000000000000066655555555666000000000000000006fffffffffffffff65555566667766006777776666776600a44444777744444a
66777777777777660000000000000000665555555555556600000000000000006fffffffffffffff66555666666666606677766666666660a44444477444444a
67777777777777766666666667776600655555555555555666666666677766006fffffffffffffff06666600000000000666660000000000a44444444444444a
66777777777777666666666666666660665555555555556666666666666666606fffffffffffffff00666000000000000066600000000000a45555445555544a
66667777777766666565656565650000666655555555666665656565656500006fffffffffffffff00000000000000000000000000000000a45666545666654a
06666777777666666000000000000000066666666666666660000000000000006fffffffffffffff00000000000000000000000000000000a45666545666654a
0066666776666660000000000000000000666766666666600000000000000000000000000000000006666600000000000000000000000000a45666545666654a
0006666666666600000000000000000000066666666666000000000000000000000000000000000066777660000000000000000000000000a45555545655544a
0000065656560000000000000000000000000656565600000000000000000000000000000000000067777766667766000066600000000000a45666655654444a
0000000000000000000000000000000000000000000000000000000000000000000000000000000066777666666666600666660000000000a45666655654444a
0000000000000000000000000000000000000000000000000000000000000000000000000000000006676600000000006655566666666600a45666655654444a
0000000000000000000000000000000000000000000000000000000000000000000000000000000000666000000000006555556666776660a45555545554444a
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006655566000000000a44444444444444a
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006666600000000000aaaaaaaaaaaaaa0
00000077770000000000000000000000fffffffff00000000000000fffffffff0000000000000000000000000000000000000000000000000000000000000000
00007777777700000000000000000000ffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
06677777777776600000000000000000777777777ffffffffffffff7777777770000000000000000066666667777777777777777777777700000000000000000
66777777777777760000000000000000777777777777777777777777777777770000000000006666666666666666666666666666666666677777000000000000
67777777777777766666666667776600111111117777777777777777111111110000000000666666666555555555555555555555555556666667770000000000
66777777777777666666666666666660777777771111111711111111777777770000000066666655555555555555555555555555555555555566677700000000
66667777777766666565656565650000777777777777777177777777777777770000006666665555555555555555555555555555555555555555666677000000
06666666666666666000000000000000777777777777777777777777777777770000066655555555555555555555555555555555555555555555555577700000
00666766666666600000000000000000777777777777777777777777778877770000066555555555555555555555555555555555555555555555555556600000
00066666666666000000000000000000788877888777888777888788877877770000066655555555555555555555555555555555555555555555555566600000
00000656565600000000000000000000788888888777888777888788877777770000066666755555555555555555555555555555555555555555577766600000
00000000000000000000000000000000788788788778888877888888877888870000006666777555555555555555555555555555555555555557776666000000
00000000000000000000000000000000788788788778878877778887777887770000006666667766655555555555555555555555555555566677666666000000
00000000000000000000000000000000788777788788888887888888877788770000000666666666666666666666666666666666666666666666666660000000
00000000000000000000000000000000788777788788888887888788877778870000000666666666666666666666666666666666666666666666666660000000
00000000000000000000000000000000788777788788777887888788877888870000000066666666666666666666666666666666666666666666666600000000
00000000000000000000000000000000777777777777777777777777777777770000000066666666676666666666666666666666666666666666666600000000
000000000000000000000000000000007a9888898777a98888a98a98988877770000000006666666676666666666666666666666666666666666666000000000
000000000000000000000000000000007a9877a9877a9877a9898a9898a987770000000006666666666666666666666666666666666666666666666000000000
000000000000000000000000000000007a9877a9877a9877a9898a9898a987770000000000666666667666666666666666666666666666666666660000000000
000000000000000000000000000000007a9888a9877a9877a9898a98988887770000000000066666667666666666666666666666666666666666600000000000
000006565656000000000000000000007a9877a9877a9877a9898a98989877770000000000066666666666666666666666666666666666666666600000000000
000666666666660000000000000000007a98777a9888a988887a988798a987770000000000006666666666666666666666666666666666666666000000000000
00666766666666600000000000000000777777777777777777777777777777770000000000000666666666666666666666666666666666666660000000000000
06666666666666666000000000000000777777777777777777777777777777770000000000000666666666666666666666666666666666666660000000000000
66665555555566666565656565650000777777777777777aa7777777777777770000000000000066666666666666666666666666666666666600000000000000
665555555555556666666666666666607777777777777aaaaaa77777777777770000000000000066666666666666666666666666666666666600000000000000
65555555555555566666666667776600111777777777777aa7777777777771110000000000000006666666666666666666666666666666666000000000000000
66555555555555660000000000000000777111117777777777777777111117770000000000000000666666666666666666666666666666660000000000000000
06665555555566600000000000000000677777771111111111111111777777760000000000000000066666666666666666666666666666600000000000000000
00666666666666000000000000000000667777777777777777777777777777660000000000000000006666666666666666666666666666000000000000000000
00000000000000000000000000000000066666666666666666666666666666600000000000000000000666666666666666666666666660000000000000000000
05555555555555500000000000000000000000000000000000000000000000000000000000000000000066666666666666666666666600000000000000000000
55555555555555550666660000000000064446000000000000000000000000000000000000000000000006666666666666666666666000000000000000000000
55555544445555556655566000000000644444600000000000000000000000000000000000000000000000066666666666666666600000000000000000000000
15151444444151516555556667766600644444666776660000000000000000000000000000000000000000000006666666666000000000000000000000000000
55444444444444556655566666666660664446666666666000000000000000000000000000000000000000000000000000000000000000000000000000000000
5744d44744d447450666660000000000066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
747d4d747d4d74750066600000000000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
744d4d744d4d74750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
744d4d744d4d74750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
747d4d747d4d77750666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5744d44744d474756644466000000000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55444444444444556444446667766600066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15151444444151516644466666666660665556666776666000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555444444555550644460000000000655555666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555544445555550064600000000000665556600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555555555555500000000000000000066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000e
e0eeeeee0eee0eeeeeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eeeeeeeeee0eee0eeeeee0e
e0e0ee0e0eee00000eeeee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00eeeee00000eee0e0ee0e0e
e0e0ee0e0eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eee0e0ee0e0e
e000ee000eee000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eee000ee000e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e00000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000e
e0e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e0e
e0e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e0e
e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e
e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777777777eeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee777777777777eeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777eeeee777ee77777777777777eeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7777777777eeee777777eee77777e79799979999997eeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee777777777777eeee777777777777ee77777777e777777779799999999997eeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777ee77777777777777e79799797779999977979977777777eeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee777777777777ee77777777777777777797999999997977797997977999999779999999977777eeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777e799799799999979779999977779979977999979999999977799999999999997eeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeee7777eeeeee7777e777777777777777779999999999999977999977ee7797997799999999999977e799999999999997eeeeeeeee
eeeeeeeeee777777777777ee777777eeee77777779979979997997977999997777779997799997eeee79999779999999999977ee799977777777997eeeeeeeee
eeeeeeeee77777777777777e777777eeee77777779999999999997977999977eeee79997799997eeee79999779999999999977ee79997eeeeee7777eeeeeeeee
eeeeeeee7777777777777777779997eeee7997977999997777999797799997eeeeee777e7999977ee7799997799999999999977e799977777777777eeeeeeeee
eeeeeeee7997997999999797799997eeee7999977999977ee7799997799997eeeeee777e799999777799999779999999999999777494949494949497eeeeeeee
eeeeeeee7999999999999997799997eeee799997799997eeee7999977999977eeee79997799999999999999779999997799999977444444444444477eeeeeeee
eeeeeeee7999997777779997799997eeee7999977999997ee7999997799999777777999779999999999999977949494777949497744444444444477eeeeeeeee
eeeeeeee7999977eeee79997799997eeee79999779999997799999977999999999999997749494944949494774444447e7744447e7777777777777eeeeeeeeee
eeeeeeee799997eeeeee777e7999977ee779999779999999999999777494949494949497744444777744444774444447ee774447eeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee799997eeeeee777e7999997777999997799999999999977e74444444444444477444477ee7744447e777777eeee7777eeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee7999977eeee79997799999999999999779494947777777ee7744444444444447e77777eeee77777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee7999997777779997749494949494949774444447eeeeeeeee77777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee7999999999999997744444444444444774444447eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee74949494949494977744444444444447e777777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee7444444444444447e77777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeee7744444444444447eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeee77777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee70777777777777777777777777777777777777777777777777777777777777777777707eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77770007000770070707777700070777077777770007070700070007700700777007777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77770007070707770707777707070777077777770707070770777077070707070777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77770707000700070007777700070777077777770077070770777077070707070007777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77770707070777070707777707070777077777770707070770777077070707077707777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77770707070700770707777707070007000777770007700770777077007707070077777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee70777777777777777777777777777777777777777777777777777777777777777777707eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeee77777777777777777777777777777777777777777777777777777777777777777777777eeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e
e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e
e0e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e0e
e0e0e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e0e0e
e00000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0e
e000ee000eee000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000eee000ee000e
e0e0ee0e0eee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eee0e0ee0e0e
e0e0ee0e0eee00000eeeee00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00eeeee00000eee0e0ee0e0e
e0eeeeee0eee0eeeeeeeeee0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0eeeeeeeeee0eee0eeeeee0e
e000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee

__map__
01020706010a01020c0d10111415000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03040305090b03040f0e12131617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181918191819181918191819181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2829282928292829282928292829282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181918191819181918191819181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2829282928292829282928292829282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181918191819181918191819181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2829282928292829282928292829282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181918191819181918191819181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2829282928292829282928292829282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1819181918191819181918191819181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2829282928292829282928292829282900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011e00100d5130d523000000d513000000f523000000d5130d5130d523000000d513000000d523000000c52300000000000000000000000000000000000000000000000000000000000000000000000000000000
011e0020247322b72528700247322d72500000247322d7222f715000002b7322872226735000002773228722247322b72500000247322d72500000247322d7222f7150000024732277222b722307552b70000000
01120020377150000037715000003b71500000000003400037715377153c000377153b715350003900039000377150000037715000003b7153b71500000340003c71539715377153b7153c715350003900039000
011200200c525000000000024200000000000024200240000c5250c52500000000000c525115250e5250c5250c5250c52500000000000c500115000e5000c5000c5250c52500000000000c525115250e5250c525
011200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00014244
03 02034344
02 40424344

