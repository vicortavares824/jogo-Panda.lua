-- Módulos e dependências
suit = require 'biblioteca/suit'
opcao = require 'fuction/opcao'
button = require 'fuction/button'
sons = require 'fuction/sons'
anim8 = require "biblioteca/anim8"
sti = require "biblioteca/sti"
camera = require"biblioteca/camera"
wf = require 'biblioteca/windfield'
local LG = love.graphics
local LK = love.keyboard
local gameMap = sti('mapa/fase 1/fase1.lua')
-- Configurações e variáveis do jogo
polyline = {
            { x = 0, y = 0 },
            { x = 704, y = 0 },
            { x = 704, y = -16 },
            { x = 720, y = -16 },
            { x = 720, y = -32 },
            { x = 816, y = -32 },
            { x = 816, y = -16 },
            { x = 832, y = -16 },
            { x = 832, y = 0 },
            { x = 1536, y = 0 },
            { x = 1536, y = 16 },
            { x = 1552, y = 16 },
            { x = 1552, y = 32 },
            { x = 2016, y = 32 },
            { x = 2016, y = 16 },
            { x = 2032, y = 16 },
            { x = 2032, y = 0 },
            { x = 4576, y = 0 },
            { x = 4576, y = 16 },
            { x = 4608, y = 16 },
            { x = 4608, y = 32 },
            { x = 4640, y = 32 },
            { x = 4640, y = 48 },
            { x = 4672, y = 48 },
            { x = 4672, y = 64 },
            { x = 4704, y = 64 },
            { x = 4704, y = 80 },
            { x = 4736, y = 80 },
            { x = 4736, y = 96 },
            { x = 4800, y = 96 }
            }
local jogo = {
  sons = { value = 30, max = 100 },
  brilho = { value = 100, max = 100 },
  telaCheia = false,
  larguraBotaoBase = 300,
  alturaBotaoBase = 30,
  larguraBotao = 300,
  alturaBotao = 30,
  indice = 1,
  tempoAnimacao = 0.2,
  larguraTela = LG.getWidth(),
  alturaTela = LG.getHeight(),
  posicaoBotaoX = 0,
  posicaoBotaoY = 0,
  escalaX = 1,
  escalaY = 1,
  imagemFundo = nil,
  animacaoFundo = nil,
  larguraFrame = 170,
  alturaFrame = 128,
  fonte = nil,
  exibirMensagem1 = false,
  exibirMensagem2 = false,
  exibirBotoes = true,
 
  mapaLargura = 9000,
  mapaAltura = gameMap.height * gameMap.tileheight,
  mapLargura = 1,
  mapAltura = 1,
  escala=1,
  escalaBloco = 1.875
}
local player = {
    x = 345,
    y = 134,
    speed = 200,
    spLeft = LG.newImage('Sprit shet/panda andando.png'),
    spRiht = LG.newImage('Sprit shet/panda andando right.png'),
    grid = nil,
    grid1 = nil,
    anim = nil,
    lado = LG.newImage('Sprit shet/panda andando.png'),
    collider = nil,
    jumpCooldown = 0 -- Tempo de recarga para o próximo pulo
}

-- Função para atualizar as dimensões da tela e posição dos botões
local function atualizarTamanhoTela()
  jogo.larguraTela = LG.getWidth()
  jogo.alturaTela = LG.getHeight()
  jogo.posicaoBotaoX = (jogo.larguraTela - jogo.larguraBotao) / 2
  jogo.posicaoBotaoY = (jogo.alturaTela - jogo.alturaBotao) / 2
  jogo.escalaX = jogo.larguraTela / jogo.larguraFrame
  jogo.escalaY = jogo.alturaTela / jogo.alturaFrame
  jogo.mapLargura = jogo.larguraTela / jogo.mapaLargura
    jogo.mapAltura = jogo.alturaTela / jogo.mapaAltura
    
end

-- Função de carregamento do jogo
function love.load()
  world = wf.newWorld(0,500)
  cam = camera()
  sons(jogo.sons,true,true)
    player.animation = {}
    player.grid = anim8.newGrid(64,64,player.spLeft:getWidth(),player.spLeft:getHeight())
    player.animation.left = anim8.newAnimation(player.grid('2-7',1),0.2)
    player.grid1 = anim8.newGrid(64,64,player.spRiht:getWidth(),player.spRiht:getHeight())
    player.animation.right = anim8.newAnimation(player.grid1('2-7',1),0.2)
    player.anim = player.animation.left
  jogo.fonte = LG.newFont('font.ttf', 26)
  LG.setFont(jogo.fonte)
  player.collider = world:newBSGRectangleCollider(400,250,45,70,10)
  player.collider:setFixedRotation(true)
  player.collider:setMass(1)
  LG.setDefaultFilter("nearest", "nearest")
  jogo.imagemFundo = LG.newImage("sprits/reprodução de fundo.png")

  atualizarTamanhoTela()

  local grid = anim8.newGrid(jogo.larguraFrame, jogo.alturaFrame, jogo.imagemFundo:getWidth(), jogo.imagemFundo:getHeight())
  jogo.animacaoFundo = anim8.newAnimation(grid('1-119', 1), jogo.tempoAnimacao)
 



local Walls = {}
for i = 1, #polyline - 1 do
  local p1 = polyline[i]
  local p2 = polyline[i + 1]
  local scaled_x1 = p1.x * jogo.escalaBloco
  local scaled_y1 = p1.y * jogo.escalaBloco
  local scaled_x2 = p2.x * jogo.escalaBloco
  local scaled_y2 = p2.y * jogo.escalaBloco
  local wall = world:newLineCollider(scaled_x1, scaled_y1+330, scaled_x2, scaled_y2+330)
  wall:setType('static')
  table.insert(Walls, wall)
end
  
  
end

-- Função de atualização do jogo
function love.update(dt)
  local isMove = false
  
  -- Atualiza o cooldown do pulo
  if player.jumpCooldown > 0 then
    player.jumpCooldown = player.jumpCooldown - dt
  end

  if LK.isDown("escape") then
    jogo.exibirBotoes = true
  end
  
 
  

  if not exibirBotoes then
    jogo.exibirMensagem1, jogo.exibirMensagem2, jogo.exibirBotoes = button.draw(
      jogo.exibirBotoes,
      jogo.posicaoBotaoX,
      jogo.posicaoBotaoY,
      jogo.larguraBotao,
      jogo.larguraBotaoBase,
      jogo.alturaBotaoBase,
      jogo.telaCheia,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2
    )
  end
 
  if jogo.exibirMensagem1 then
    local velx= 0
    local currentVelY= 0 
    local _ , vy = player.collider:getLinearVelocity()
    currentVelY = vy
    if LK.isDown("right") then
  if player.x < (9500 - player.spRiht:getWidth() ) then -- Adicionei uma verificação de limite direito
    player.x = player.x + player.speed * dt -- Corrigido para adicionar (mover para a direita)
    velx = player.speed
    player.anim = player.animation.right
    player.lado = player.spRiht
    sons(jogo.sons,false,"andar")
  end
  isMove = true
elseif LK.isDown("left") then
  if player.x > 0 then -- Mantenha a verificação de limite esquerdo
    player.x = player.x - player.speed * dt -- Mantido para subtrair (mover para a esquerda)
    velx = -player.speed
    player.anim = player.animation.left
    player.lado = player.spLeft
    sons(jogo.sons,false,"andar")
  end
  isMove = true
end



    player.collider:setLinearVelocity(velx,currentVelY)
  end
  if not isMove then
    player.anim:gotoFrame(2)
    if jogo.exibirMensagem1 then
      sons(jogo.sons,false,"para")
    end
  end
  world:update(dt)
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  player.anim:update(dt)

  jogo.animacaoFundo:update(dt)
  local targetY = jogo.alturaTela / 2
  cam:lookAt(player.x, targetY)

  if cam.x < jogo.larguraTela / 2 then
    cam.x = jogo.larguraTela / 2
  elseif cam.x > jogo.mapaLargura - jogo.larguraTela / 2 then
    cam.x = jogo.mapaLargura - jogo.larguraTela / 2
  end

  -- Redefine o cooldown quando o jogador tocar o chão
  if player.collider:enter('Ground') then
    player.jumpCooldown = 0 -- Permite pular imediatamente ao tocar o chão
  end
  
end

-- Função de desenho do jogo
function love.draw()
  local escala = math.max(jogo.escalaX, jogo.escalaY)
  if not jogo.exibirMensagem1 then
    jogo.animacaoFundo:draw(jogo.imagemFundo, 0, 0, 0, escala, escala)
  end
  
  if LK.isDown("up", "space") then
    if player.jumpCooldown <= 0 then
      sons(jogo.sons,false,"pular")
        player.collider:applyLinearImpulse(0, -200) -- Aplica o impulso para o pulo
        player.jumpCooldown = 1 -- Define o cooldown para o pulo
       
      end
  end

  if jogo.exibirMensagem2 then
    jogo.exibirMensagem2, jogo.exibirBotoes, jogo.telaCheia = opcao(
      jogo.posicaoBotaoX + 30,
      jogo.posicaoBotaoY - 40,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2,
      jogo.sons,
      jogo.brilho,
      jogo.exibirBotoes
    )
    jogo.exibirBotoes = not jogo.exibirMensagem2
  end
   if jogo.exibirMensagem1 then
    sons(jogo.sons,false,nil)
    jogo.escala = math.max(jogo.mapLargura, jogo.mapAltura)
    cam:attach()
    LG.push() -- Salva o estado atual da matriz de transformação
    LG.scale(jogo.escala, jogo.escala)

    gameMap:drawLayer(gameMap.layers["Fundo"])
    gameMap:drawLayer(gameMap.layers["Nuvem"])
    gameMap:drawLayer(gameMap.layers["Chao"])
    gameMap:drawLayer(gameMap.layers["Enfeite"])
    LG.pop() -- Restaura o estado da matriz de transformação
    LG.setDefaultFilter("nearest", "nearest")
    player.anim:draw(player.lado, player.x - 57, player.y - 80, nil, 1.8)
    --world:draw()
    cam:detach()
  end
  -- Mova o suit.draw() para o final para que ele seja desenhado por último
  suit.draw()
end