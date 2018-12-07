import Test.Hspec
import ADTs (readNumbers_do, Error(NotIntParseable))

main :: IO ()
main = hspec $ do
  describe "readNumbers_do" $ do
    it "can read two numbers" $ do
        readNumbers_do "1" "2" `shouldBe` Right (1,2)
        readNumbers_do "-1" "0" `shouldBe` Right (-1,0)
        readNumbers_do "10000000" "123456789" `shouldBe` Right (10000000,123456789)
    it "can produce a legible error message" $ do
        readNumbers_do "1" "abc" `shouldBe` Left (NotIntParseable "Bad \"abc\"" "\"abc\"")
        readNumbers_do "1.1" "2" `shouldBe` Left (NotIntParseable "Bad \"1.1\"" "\"1.1\"")
        readNumbers_do "1.1" "abc" `shouldBe` Left (NotIntParseable "Bad \"1.1\"" "\"1.1\"")
