function sons(slider)
   src1 = love.audio.newSource("soud/8bit-music.mp3", "static")
    src1:setLooping(true)
    src1:setVolume(slider.value/100) 
    src1:play()
end
return sons