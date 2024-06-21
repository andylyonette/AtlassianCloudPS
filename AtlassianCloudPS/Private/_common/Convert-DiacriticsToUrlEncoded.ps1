function Convert-DiacriticsToUrlEncoded {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )

    $lookup = New-Object system.collections.hashtable
    $lookup.'À' = '&#192;'  #A, grave
    $lookup.'Á' = '&#193;'  #A, acute
    $lookup.'Â' = '&#194;'  #A, circumflex
    $lookup.'Ã' = '&#195;'  #A, tilde
    #$lookup.'Ä' = '&#196;'  #A, umlaut
    $lookup.'Å' = '&#197;'  #A, ring
    $lookup.'Æ' = '&#198;'  #AE, dipthong
    $lookup.'Ç' = '&#199;'  #C, cedilla
    $lookup.'È' = '&#200;'  #E, grave
    $lookup.'É' = '&#201;'  #E, acute
    $lookup.'Ê' = '&#202;'  #E, cicumflex
    $lookup.'Ë' = '&#203;'  #E, umlaut
    $lookup.'Ì' = '&#204;'  #I, grave
    $lookup.'Í' = '&#205;'  #I, acute
    $lookup.'Î' = '&#206;'  #I, circumflex
    $lookup.'Ï' = '&#207;'  #I, umlaut
    $lookup.'Ð' = '&#208;'  #Eth, Icelandic
    $lookup.'Ñ' = '&#209;'  #N, tilde
    $lookup.'Ò' = '&#210;'  #O, grave
    #$lookup.'Ó' = '&#211;'  #O, acute
    #$lookup.'Ô' = '&#212;'  #O, circumflex
    $lookup.'Õ' = '&#213;'  #O, tilde
    $lookup.'Ö' = '&#214;'  #O, umlaut
    $lookup.'×' = '&#215;'  #multiply sign
    $lookup.'Ø' = '&#216;'  #O, slash
    $lookup.'Ù' = '&#217;'  #U, grave
    $lookup.'Ú' = '&#218;'  #U, acute
    $lookup.'Û' = '&#219;'  #U, circumflex
    $lookup.'Ü' = '&#220;'  #U, umlaut
    $lookup.'Ý' = '&#221;'  #Y, acute
    $lookup.'Þ' = '&#222;'  #THORN, Icelandic
    $lookup.'ß' = '&#223;'  #eszett
    $lookup.'à' = '&#224;'  #a, grave
    $lookup.'á' = '&#225;'  #a, acute
    $lookup.'â' = '&#226;'  #a, circumflex
    $lookup.'ã' = '&#227;'  #a, tilde
    $lookup.'ä' = '&#228;'  #a, umlaut
    $lookup.'å' = '&#229;'  #a, ring
    $lookup.'æ' = '&#230;'  #ae, dipthong
    $lookup.'ç' = '&#231;'  #c, cedilla
    $lookup.'è' = '&#232;'  #e, grave
    $lookup.'é' = '&#233;'  #e, acute
    $lookup.'ê' = '&#234;'  #e, cicumflex
    $lookup.'ë' = '&#235;'  #e, umlaut
    $lookup.'ì' = '&#236;'  #i, grave
    $lookup.'í' = '&#237;'  #i, acute
    $lookup.'î' = '&#238;'  #i, circumflex
    $lookup.'ï' = '&#239;'  #i, umlaut
    $lookup.'ð' = '&#240;'  #eth, Icelandic
    $lookup.'ñ' = '&#241;'  #n, tilde
    $lookup.'ò' = '&#242;'  #o, grave
    $lookup.'ó' = '&#243;'  #o, acute
    $lookup.'ô' = '&#244;'  #o, circumflex
    $lookup.'õ' = '&#245;'  #o, tilde
    $lookup.'ö' = '&#246;'  #o, umlaut
    $lookup.'÷' = '&#247;'  #divide sign
    $lookup.'ø' = '&#248;'  #o, slash
    $lookup.'ù' = '&#249;'  #u, grave
    $lookup.'ú' = '&#250;'  #u, acute
    $lookup.'û' = '&#251;'  #u, circumflex
    $lookup.'ü' = '&#252;'  #u, umlaut
    $lookup.'ý' = '&#253;'  #y, acute
    $lookup.'þ' = '&#254;'  #thorn, Icelandic
    $lookup.'ÿ' = '&#255;'  #y, umlaut

    foreach ($key in $lookup.Keys){
        $String = $String.Replace($key,$lookup.$key)
    }

    return $String
}