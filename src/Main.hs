{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Conduit
import           Data.CSV.Conduit
import qualified Data.Map         as M
import qualified Data.Text as T
import           Types
import Data.Aeson

type TapT m = ConduitT () Message m ()
type Tap = TapT IO
type Target m = ConduitT Message () m ()

messageTransformer :: Monad m => FilePath -> ConduitT (MapRow T.Text) Message m ()
messageTransformer fp = mapC $ \map -> MessageRecord (RecordMessage fp "" (M.mapKeys T.unpack . fmap T.unpack $ map)) 

csvTapT :: (MonadResource m, MonadThrow m) => FilePath -> TapT m 
csvTapT fp = sourceFile fp .| intoCSV defCSVSettings .| messageTransformer fp

runTap :: TapT m -> IO ()
runTap t = runConduitRes $ t .| mapC encode .| printC 

main :: IO ()
main = runTap $ csvTapT "file"
