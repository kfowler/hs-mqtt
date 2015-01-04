module Main where

import qualified Data.ByteString.Lazy.Char8 as BL
import           Network.AMQP

main ::  IO ()
main = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn


  consumeMsgs chan "test-queue" Ack simpleCallback

  getLine
  closeConnection conn
  print "connection closed"

simpleCallback ::  (Message, Envelope) -> IO ()
simpleCallback (msg,env) = do
               print $ "received message : " ++ (BL.unpack $ msgBody msg)
               ackEnv env







