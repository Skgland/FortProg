#!/usr/bin/ghci
module Baeume where
import Data.List hiding (insert)
import Test.QuickCheck

data SearchTree = Empty | Branch SearchTree Int SearchTree
  deriving (Eq, Show)

data Tree = Leaf Int | Node Tree Tree deriving (Eq, Show)

size::Tree->Int
size (Leaf _) = 1;
size (Node a b) = (size a)+(size b)

insert :: Int -> SearchTree -> SearchTree
insert x Empty          = Branch Empty x Empty
insert x (Branch l n r)
  | x == n    = Branch l n r
  | x <  n    = Branch (insert x l) n r
  | otherwise = Branch l n (insert x r)

isEmpty::SearchTree->Bool
isEmpty Empty = True
isEmpty _     = False

contains::Int->SearchTree->Bool
contains elem (Branch _ i _) | i==elem = True
contains elem (Branch a _ b) = (contains elem a)||(contains elem b)
contains _ Empty = False

treeFromList::[Int] -> SearchTree
treeFromList = foldr insert Empty

flachKlopfen::SearchTree->[Int]
flachKlopfen Empty = []
flachKlopfen (Branch a i b) = (flachKlopfen a)++[i]++(flachKlopfen b)

toList::Tree->[Int]
toList (Leaf i) = [i]
toList (Node t1 t2) = (toList t1) ++ (toList t2)

prop_add_not_empty::[Int]->Int->Bool
prop_add_not_empty list = not.isEmpty.(flip insert $ (treeFromList list))

prop_add_contains::Int->[Int]->Bool
prop_add_contains elem list = (contains elem).(insert elem) $ (treeFromList list)

prop_flat_knocking_sorted::[Int]->Bool
prop_flat_knocking_sorted list = (flachKlopfen.treeFromList $ list) == (sort.nub $ list)

prop_tree_size_check::Tree->Property
prop_tree_size_check tree = collect (size tree) $ (length.toList $ tree) == (size tree)

instance Arbitrary Tree where
    arbitrary = do
                    a <- arbitrary 
                    b <- arbitrary
                    d <- elements [Empty,Node a b]
                    in 
                        d
