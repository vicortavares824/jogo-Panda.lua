-- Módulos e dependências
suit = require 'biblioteca/suit'
opcao = require 'fuction/opcao'
button = require 'fuction/button'
sons = require 'fuction/sons'
anim8 = require "biblioteca/anim8"
sti = require 'biblioteca/sti'
-- Configurações e variáveis do jogo
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
  larguraTela = love.graphics.getWidth(),
  alturaTela = love.graphics.getHeight(),
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
}


-- Função para atualizar as dimensões da tela e posição dos botões
local function atualizarTamanhoTela()
  jogo.larguraTela = love.graphics.getWidth()
  jogo.alturaTela = love.graphics.getHeight()
  jogo.posicaoBotaoX = (jogo.larguraTela - jogo.larguraBotao) / 2
  jogo.posicaoBotaoY = (jogo.alturaTela - jogo.alturaBotao) / 2
  jogo.escalaX = jogo.larguraTela / jogo.larguraFrame
  jogo.escalaY = jogo.alturaTela / jogo.alturaFrame
end

-- Função de carregamento do jogo
function love.load()
  sons(jogo.sons)

  jogo.fonte = love.graphics.newFont('font.ttf', 26)
  love.graphics.setFont(jogo.fonte)

  love.graphics.setDefaultFilter("nearest", "nearest")
  jogo.imagemFundo = love.graphics.newImage("sprits/reprodução de fundo.png")

  atualizarTamanhoTela()

  local grid = anim8.newGrid(jogo.larguraFrame, jogo.alturaFrame, jogo.imagemFundo:getWidth(), jogo.imagemFundo:getHeight())
  jogo.animacaoFundo = anim8.newAnimation(grid('1-119', 1), jogo.tempoAnimacao)
 
 
end

-- Função de atualização do jogo
function love.update(dt)
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
  

  jogo.animacaoFundo:update(dt)
end
-- Função de desenho do jogo
function love.draw()
  local escala = math.max(jogo.escalaX, jogo.escalaY)
  if not jogo.exibirMensagem1 then
    jogo.animacaoFundo:draw(jogo.imagemFundo, 0, 0, 0, escala, escala)
  end

  suit.draw()

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
    
  end
end