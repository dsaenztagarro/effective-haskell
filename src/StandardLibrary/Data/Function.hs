{-# LANGUAGE NoImplicitPrelude #-}
module StandardLibrary.Data.Function where

import StandardLibrary.Data.Functor
import StandardLibrary.Control.Applicative
import Prelude (const, (.), ($))

newtype Function a b = Function { runFunction :: a -> b }

instance Functor (Function a) where
  -- fmap :: (b -> c) -> Function a b -> Function a c
  fmap f (Function g) = Function (f . g)

instance Applicative (Function a) where
  pure a = Function $ const a
  -- (<*>) :: Function a (b -> c) -> Function a b -> Function a c
  Function f <*> Function g = Function $ \value -> f value (g value)

