require 'telegram/bot'
require 'dotenv/load'
require 'logger'

TOKEN = ENV['TELEGRAM_BOT_TOKEN']
logger = Logger.new($stdout)

begin
  logger.info("Iniciando bot com token: #{TOKEN[0..3]}...") # Mostra apenas parte do token

  Telegram::Bot::Client.run(TOKEN) do |bot|
    bot.logger = logger
    logger.info("Bot conectado! Aguardando mensagens...")

    bot.listen do |message|
      logger.info("Recebido: #{message.text}")
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Olá! Recebi sua mensagem: #{message.text}"
      )
    end
  end
rescue => e
  logger.error("ERRO: #{e.message}")
  sleep 5 # Pausa para evitar loops rápidos
  retry
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.api.delete_webhook # Garante que não está em modo webhook
  # ... resto do código ...
end
