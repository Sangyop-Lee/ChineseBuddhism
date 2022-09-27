xquery version "3.0";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace cb="http://www.cbeta.org/ns/1.0";

let $source := doc('/Users/sangyoplee/onedrive/programming/typo_database/alltaisho/T09/T09n0263_002.xml')
let $title := data($source//tei:body//cb:juan[1])
let $text := data($source//tei:body)
let $mani := translate($text,"：；，。《》（）「」！？『』、0123456789 ,.()[]abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ","")
let $wordcount := string-length($mani)

let $textlist := doc('/Users/sangyoplee/onedrive/programming/typo_database/zhufoniantn.xml')
let $numberlist := doc('/Users/sangyoplee/onedrive/programming/typo_database/numbers.xml')

let $textnums := data($textlist//t)
let $numberdata := data($numberlist//n)

let $textlocbases := for $textnum in $textnums
                    let $textvol := substring($textnum,1,3)
                    let $textlocbase := concat("/Users/sangyoplee/onedrive/programming/typo_database/alltaisho/", $textvol, "/", $textnum, "_", "ㄱㄴㄷ",".xml")
                    return $textlocbase

let $textlocs := <xml>{
                    for $textlocbase in $textlocbases
                    return if (1!=number(translate(data(doc(translate($textlocbase,"ㄱㄴㄷ","001"))//tei:extent),"卷","")))
                      then                     
                    <text>{
                      for $number in $numberdata
                      let $textloc := translate($textlocbase,"ㄱㄴㄷ",$number)
                      return 
                         if (number($number) le number(translate(data(doc(translate($textlocbase,"ㄱㄴㄷ","001"))//tei:extent),"卷","")))
                          then <loc>{$textloc}</loc>}
                      </text>}</xml>

let $textlocdata := data($textlocs//loc)

let $textlength := for $textloc in $textlocdata
                      let $individualtext := doc($textloc)
                      let $individualtextdata := data($individualtext//tei:body)
                      let $individualtextmani := translate($individualtextdata,"：；，。《》（）「」！？『』、0123456789 ,.()[]abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ","")
                      let $individualtextlength := string-length($individualtextmani)
                      return $individualtextlength

let $textlengthxml := for $textloc in $textlocdata
                      let $individualtext := doc($textloc)
                      let $individualtextdata := data($individualtext//tei:body)
                      let $individualtextmani := translate($individualtextdata,"：；，。《》（）「」！？『』、0123456789 ,.()[]abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ","")
                      let $individualtextlength := string-length($individualtextmani)
                      return <xml>
                      <title>{data($individualtext//tei:body//cb:juan[1])}</title>
                      <taishonum>{substring($textloc,68,8)}</taishonum>
                      <fascicle>{substring($textloc,77,3)}</fascicle>
                      <length>{$individualtextlength}</length>
                      </xml>
                      
let $stringlength := string-length("/Users/sangyoplee/onedrive/programming/typo_database/alltaisho/T01/T01n0021_")

return
$textlengthxml