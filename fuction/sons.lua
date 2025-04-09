
local src1 -- Declarar src1 como uma variável local para manter o controle do áudio

function sons(slider, jogo)
    if src1 then
        src1:stop() -- Para o áudio atual antes de carregar um novo
    end

    if jogo then
        src1 = love.audio.newSource("soud/8bit-music.mp3", "static")
    else
        src1 = love.audio.newSource("soud/cottagecore.mp3", "static")
    end

    src1:setLooping(true)
    src1:setVolume(slider.value / 100)
    src1:play()
end

return sons