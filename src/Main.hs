{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Conduit
import           Data.CSV.Conduit
import qualified Data.Map         as M
import qualified Data.Text as T
import           Types
import Data.Aeson

type Tap m = ConduitT () Message (ResourceT m) ()
type Target m = ConduitT Message () (ResourceT m) ()

messageTransformer :: Monad m => FilePath -> ConduitT (MapRow T.Text) Message m ()
messageTransformer fp = mapC $ \map -> MessageRecord (RecordMessage fp "" (M.mapKeys T.unpack . fmap T.unpack $ map)) 

csvTap :: (MonadIO m, MonadThrow m) => FilePath -> Tap m 
csvTap fp = sourceFile fp .| intoCSV defCSVSettings .| messageTransformer fp

-- csvTarget :: (MonadIO m, MonadThrow m) => FilePath -> Target m
-- csvTarget fp = mapC encode .| sinkFile fp

runTap :: (MonadUnliftIO m, MonadIO m, MonadThrow m) => Tap m -> m ()
runTap t = runConduitRes $ t .| mapC encode .| printC 

main :: IO ()
main = runTap $ csvTap "test.csv"
