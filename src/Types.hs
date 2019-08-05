{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Types where

import Control.Monad
import           Data.Aeson
import qualified Data.Map     as M
import           GHC.Generics
import GHC.Exts
import qualified Data.Text as T

toObject :: ToJSON a => a -> Object
toObject a = case toJSON a of
  Object o -> o
  _        -> error "toObject: value isn't an Object"

data Message
  = MessageRecord RecordMessage
  | MessageSchema SchemaMessage
  | MessageState StateMessage
  deriving (Show, Eq, Generic)

instance ToJSON Message where
  toJSON (MessageRecord (RecordMessage s t r)) = object $ ["type" .= ("RECORD" :: T.Text), "stream" .= s, "time" .= t, "record" .= r] 
  toJSON _ = undefined

data RecordMessage = RecordMessage
  { recordMessageStream        :: String
  , recordMessageTimeExtracted :: String
  , recordMessageRecord        :: M.Map String String
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data SchemaMessage = SchemaMessage
  { schemaMessageStream :: String
  , schemaMessageSchema :: Schema
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data Schema = Schema
  { schemaProperties         :: M.Map String Property
  , schemaKeyProperties      :: [String]
  , schemaBookmarkProperties :: [String]
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data Property = Property
  { propertyType :: PropertyType
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data PropertyType
  = PropertyTypeInteger
  | PropertyTypeString
  deriving (Show, Eq, Generic, ToJSON, FromJSON)

data StateMessage = StateMessage
  { stateMessageValue :: String
  } deriving (Show, Eq, Generic, ToJSON, FromJSON)
