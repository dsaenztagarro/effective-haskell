{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Exts.GADT.CommandRunnerSpec (spec) where

import Test.Hspec
import Exts.GADT.CommandRunner
import Exts.GADT.ShellCmd
import Exts.Helper
import Data.Proxy
import System.FilePath ((</>))

verifyCommands ::
  CommandSet
    '["ls","free","uptime","cat","uname"]
    '[ ShellCmd FilePath [FilePath]
     , ShellCmd () String
     , ShellCmd () String
     , ShellCmd FilePath String
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

  describe "CommandByName'" $ do
    describe "lookupProcessByName'" $
      around withTestDir $ do
        it "runs command at head of the list" $ \testDir -> do
          let proxyTrue = Proxy @True
              proxyLs = Proxy @"ls"
              cmd = lookupProcessByName' proxyTrue proxyLs commands
          fileNames <- runShellCmd cmd testDir
          fileNames `shouldBe`
            [ testDir </> "FileA.hs"
            , testDir </> "FileB.hs"
            , testDir </> "FileC.hs"
            ]

        it "runs command at tail of the list" $ \testDir -> do
          let proxyFalse = Proxy @False
              proxyCat = Proxy @"cat"
              cmd = lookupProcessByName' proxyFalse proxyCat commands
          output <- runShellCmd cmd (testDir </> "FileA.hs")
          output `shouldBe` "module FileA where"

  describe "CommandByName" $ do
    describe "lookupProcessByName" $
      around withTestDir $ do
        it "runs command at head of the list" $ \testDir -> do
          let cmd = lookupProcessByName (Proxy @"ls") commands
          fileNames <- runShellCmd cmd testDir
          fileNames `shouldBe`
            [ testDir </> "FileA.hs"
            , testDir </> "FileB.hs"
            , testDir </> "FileC.hs"
            ]

        it "runs command at tail of the list" $ \testDir -> do
          let cmd = lookupProcessByName (Proxy @"cat") commands
          output <- runShellCmd cmd (testDir </> "FileA.hs")
          output `shouldBe` "module FileA where"

  describe "runNamedCommand" $ do
    around withTestDir $ do
      it "runs command at head of the list" $ \testDir -> do
        fileNames <- runNamedCommand @"ls" commands testDir
        fileNames `shouldBe`
          [ testDir </> "FileA.hs"
          , testDir </> "FileB.hs"
          , testDir </> "FileC.hs"
          ]

      it "runs command at tail of the list" $ \testDir -> do
        output <- runNamedCommand @"cat" commands (testDir </> "FileA.hs")
        output `shouldBe` "module FileA where"
