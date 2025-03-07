{-# LANGUAGE NoImplicitPrelude #-}

module Std.Control.Alternative where

import Std.Control.Applicative
import Std.Data.Functor

-- Effective Haskell (page 457)
class Applicative f => Alternative f where
  empty :: f a
  (<|>) :: f a -> f a -> f a
  some :: f a -> f [a]
  many :: f a -> f [a]
  {-# MINIMAL empty, (<|>), some, many #-}

-- optional :: Alternative f => f a -> f (Maybe a)
-- optional v = Just <$> v <|> pure Nothing
