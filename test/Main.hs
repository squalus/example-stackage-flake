module Main
where

import qualified Data.Vector as V
import Test.Tasty
import Test.Tasty.HUnit

import System.IO (BufferMode (..), hSetBuffering, stderr, stdout)

import Example

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    hSetBuffering stderr NoBuffering
    tests' <- tests
    defaultMain tests'

tests :: IO TestTree
tests = do
    pure $
        testGroup
            "Example"
            [ testExample1
            ]

testExample1 :: TestTree
testExample1 = testCase "example1" $ do
    let out = example1
    assertEqual "" [1, 2, 3] (V.toList out)
