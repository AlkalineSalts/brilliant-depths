local timeFunc = os.time
function getSystemTime() return timeFunc() end
os = nil 
io = nil