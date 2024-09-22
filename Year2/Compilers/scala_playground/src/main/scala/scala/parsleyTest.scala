package scala
import parsley.Parsley
import parsley.Parsley._
import parsley.character.{satisfy, string}
import parsley.implicits.character.stringLift

object parsleyTest {
  val p = "abc" <|> "def" <|> "dead"
  val digit: Parsley[Int] = satisfy(_.isDigit).map(_.asDigit)
  val abc = string("abc")

  def main(args: Array[String]): Unit = {

    println(p.parse("abc"))
    println(p.parse("def"))
    println(p.parse("dead"))

    println(digit.parse("2"))

  }


}
