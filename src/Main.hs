{-# LANGUAGE TemplateHaskell #-}
module Main where

import Control.Concurrent
import Language.Haskell.TH

main :: IO ()
main = do
  putStrLn "hello world"

$((runIO $ threadDelay 30000000) >> return [])
