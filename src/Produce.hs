{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GADTs         #-}

module Main where

import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as BL
import           Data.Text                  (Text)
import           GHC.Generics
import           Network.AMQP

data WorkOrder = WorkOrder { workId :: Text, workThing :: Text } deriving (Eq,Show,Generic)


instance FromJSON WorkOrder
instance ToJSON WorkOrder

workOrder = WorkOrder { workId = "EA", workThing = "delete me." }

send :: ToJSON a => Channel -> a -> IO ()
send channel workOrder = publishMsg channel "test-exchange" "test-key"
                                    newMsg { msgBody = encode workOrder, msgDeliveryMode = Just Persistent }

main ::  IO ()
main = do
  conn <- openConnection "127.0.0.1" "/" "guest" "guest"
  chan <- openChannel conn

  declareQueue chan newQueue { queueName = "test-queue" }
  declareExchange chan newExchange { exchangeName = "test-exchange", exchangeType = "direct" , exchangeDurable = True}
  bindQueue chan "test-queue" "test-exchange" "test-key"

  send chan workOrder

  closeConnection conn
  print $ BL.append (BL.pack "sent : ") (encode workOrder)
