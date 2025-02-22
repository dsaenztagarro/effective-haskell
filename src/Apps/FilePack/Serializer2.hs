{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RecordWildCards #-}
module Apps.FilePack.Serializer2 where

import Apps.FilePack.Util
import Data.ByteString (ByteString)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.Text.Encoding (encodeUtf8, decodeUtf8)
import Data.Word
import Text.Read (readEither)

newtype FilePack a =
  FilePack { getPackedFiles :: [FileData a] } deriving (Eq, Read, Show)

-- instance Encode a => (FilePack a) where
--   encode (FilePack a) = FilePack2.encode a

