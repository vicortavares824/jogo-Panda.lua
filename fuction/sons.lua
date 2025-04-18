sounds = {
    src1 = love.audio.newSource("soud/8bit-music.mp3", "stream"),
    src2 = love.audio.newSource("soud/cottagecore.mp3", "stream"),
    src3 = love.audio.newSource("soud/jump.wav", "stream"),
    src4 = love.audio.newSource("soud/footstep.wav", "stream"),
    src5 = love.audio.newSource("soud/Atirando.mp3", "stream"),
}

function sons(slider, jogo, efeito)
    -- Verifica se o slider é válido e ajusta o volume do áudio
    -- Verifica se o jogo está ativo e reproduz o áudio correspondente
    if jogo then
        sounds.src1:play()
        sounds.src2:stop()
    else
        sounds.src1:stop()
        sounds.src2:play()
    end

    -- Reproduz o efeito de som correspondente
    if efeito == "pular" then
        sounds.src3:play()
    elseif efeito == "andar" then
        sounds.src4:play()
    elseif efeito == "para" then
        sounds.src4:stop()
    elseif efeito == "atirar" then
        sounds.src5:play()
    end

    -- Retorna a tabela de sons para uso posterior, se necessário
    return sounds
end

return sons,sounds