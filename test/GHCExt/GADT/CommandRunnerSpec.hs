{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module GHCExt.GADT.CommandRunnerSpec (spec) where

import Test.Hspec
import GHCExt.GADT.CommandRunner
import GHCExt.GADT.ShellCmd
import GHCExt.Helper
import Data.Proxy
import System.FilePath ((</>))

verifyCommands :: 
  CommandSet 
    '["ls","free","uptime","uname"] 
    '[ ShellCmd FilePath [FilePath]
     , ShellCmd () String
     , ShellCmd () String
     , ShellCmd () String
     ] -> String
verifyCommands _ = "verified"

spec :: Spec
spec = do
  describe "commands" $ do
    it "creates a set of commands" $ do
      verifyCommands commands `shouldBe` "verified"

  describe "CommandByName" $ do
    around withTestDir $ do
      it "runs the first command" $ \testDir -> do
        directoryListing <- runShellCmd (lookupProcessByName (Proxy @"ls") commands) testDir
        directoryListing `shouldBe` 
          [ testDir </> "FileA.hs"
          , testDir </> "FileB.hs"
          , testDir </> "FileC.hs"
          ]
  
  describe "HeadMatches" $ do
    it "returns True type when head matches" $ do
      Proxy @(HeadMatches "foo" '["foo", "bar"]) `shouldBe` Proxy @True

    it "returns False type when head does not matches" $ do
      Proxy @(HeadMatches "bar" '["foo", "bar"]) `shouldBe` Proxy @False
