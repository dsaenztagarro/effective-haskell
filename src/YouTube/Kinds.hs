-- Tweag: @rae: An introduction to Haskell's kinds
-- https://www.youtube.com/watch?v=JleVecHAad4

{-# LANGUAGE StandaloneKindSignatures, DeriveFunctor #-}
module YouTube.Kinds where

import Prelude hiding ( not, Either(..), Monad(..) )

import Data.Kind ( Type, Constraint )

not :: Bool -> Bool
not True = False
not False = True

type Booly :: Type
data Booly = Truey | Falsey

{-
type Functor :: (Type -> Type) -> Constraint
class Functor f where
  fmap :: (a -> b) -> f a -> f b
-}

type Monad :: (Type -> Type) -> Constraint
class Monad m where
  (>>=) :: (m a) -> (a -> m b) -> m b

myId :: Monad m => m a -> m a
myId x = x

type List :: Type -> Type -- << thanks to StandaloneKindSignatures
data List a = Nil | Cons a (List a)
  deriving Functor

{-
instance Functor List where ...
-}

type Tree :: Type -> Type
data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving Functor

{-
instance Functor Tree where ...
-}

type Either :: Type -> Type -> Type
data Either a b = Left a | Right b

type ReaderT :: Type -> (Type -> Type) -> Type -> Type
newtype ReaderT e m a = MkReaderT (e -> m a)

type MonadTrans :: ((Type -> Type) -> Type -> Type) -> Constraint
class MonadTrans t where
  lift :: m a -> t m a

y :: Int
y = 5
