module Main where

import qualified Data.ByteString.Lazy.Char8 as BL
import           Network.AMQP

main ::  IO ()
main = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn

  declareQueue chan newQueue { queueName = "test-queue" }
  declareExchange chan newExchange { exchangeName = "test-exchange", exchangeType = "direct" , exchangeDurable = True}
  bindQueue chan "test-queue" "test-exchange" "test-key"

  publishMsg chan "test-exchange" "test-key"
           newMsg { msgBody = (BL.pack "hello world") , msgDeliveryMode = Just Persistent }

  closeConnection conn
  print "message sent"








