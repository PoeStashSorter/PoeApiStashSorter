;SETTINGS
global AccountName := "AccountName"
global CharacterName := "CharacterName"
global Cookie := "POESESSID=7fcXXXXXX" ;Where XXXXXX is another ~300 characters. Get this from logging into the path of exile website, pressing F12 and copying your cookie test
global stashLayout := ["currency", "maps", "cards", "essence", "fragments", "TheRest"]
global stashIgnore := [[0,0],[0,1],[0,2],[0,3],[0,4]]
global topLeftX = 1296 ;Centre top left inventory X coord
global topLeftY = 614 ;Centre top left inventory Y coord
global stepSize = 50 ;Inventory width
global stepGap = 3 ;Inventory boarder size

;SETTINGS END

global itemList := ""
global clickList := []

F6::
	;msgbox % "Starting"
	sortInventory()
	;msgbox % "Done"
return

sortInventory(){
	CoordMode, Mouse, Screen
	itemList := ""
	clickList := []
	
	URL = https://www.pathofexile.com/character-window/get-items?character=%CharacterName%&accountName=%AccountName%
	HttpObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	HttpObj.Open("POST", URL, 0)
	HttpObj.SetRequestHeader("Content-Type", "application/json")
	HttpObj.SetRequestHeader("Cookie", Cookie)
	HttpObj.SetRequestHeader("Cache-Control", "no-cache")
	HttpObj.Send()
	Result := HttpObj.ResponseText
	Status := HttpObj.Status

	if (Status != 200){
		msgbox % "Http error`n" Status "`nResult:`n" Result
	}
	
	characterParsed := JSON.Load(Result) ; convert JSON Response to AHK object
	ItemType = Unknown
	
	itemsDic := characterParsed.items

	for key, value in itemsDic {
		isInventoryItem := itemsDic[key].inventoryId
		if (isInventoryItem == "MainInventory"){
			
			for categoryKey, categoryValue in itemsDic[key].category{
				ItemType = %categoryKey%
			}
			xCoord := itemsDic[key].x
			yCoord := itemsDic[key].y
			itemDesc := itemsDic[key].typeLine
			itemMeta := [ItemType, itemDesc, xCoord, yCoord, false]
			clickList.Push(itemMeta)
		
			itemList := itemList key " " ItemType " " itemsDic[key].typeLine " x=" xCoord " y=" itemsDic[key].y "`n"
		}
	}
	aaa := getRandomVariance(10,6)
	;DEBUG
	;msgbox % "Items`n" itemList 
	;return

	Send, {Control down}
	for index, stashElement in stashLayout {
		for itemIndex, itemElement in clickList {
			if (stashElement == getItemType(itemElement.1, itemElement.2) || (stashElement == "TheRest" && itemElement.5 == false)){
			
				getX := getMouseCoordsX(itemElement.3)
				getY := getMouseCoordsY(itemElement.4)
				
				itemElement.5 := true
				
				if (isIgnoredCell(itemElement.3,itemElement.4)){
					continue
				}
				
				;msgbox % "Item`n" stashElement "`nx=" getX "`ny=" getY "`nbasex=" itemElement.2 "`nbasex=" itemElement.3
				
				MouseMove, getX, getY, getRandomVariance(3,2)
				randomSleep()
				MouseClick, left
				randomSleep()
			}
		}
		
		if (stashElement != "TheRest"){
			Send, {Right down}
			Sleep, getRandomVariance(30,6)
			Send, {Right up}
			Sleep, getRandomVariance(400,20)
		}
	}
	Send, {Control up}
	getRandomVariance(30,6)
	loop, 5 {
		Send, {Left down}
		Sleep, getRandomVariance(30,6)
		Send, {left up}
	}
}

getItemType(itemType, itemDesc){
	if InStr(itemDesc, "essence"){
		return "essence"
	}
	
	if InStr(itemDesc, "sacrifice "){
		return "fragments"
	}
	
	if InStr(itemDesc, "remnant"){
		return "essence"
	}
	
	if InStr(itemDesc, "splinter"){
		return "fragments"
	}
	
	if InStr(itemDesc, "divine vessel"){
		return "fragments"
	}
	
	if InStr(itemDesc, "offering"){
		return "fragments"
	}
	
	if InStr(itemDesc, "breachstone"){
		return "fragments"
	}
	
	if InStr(itemDesc, "fragment"){
		return "fragments"
	}
	
	if InStr(itemDesc, "key"){
		return "fragments"
	}
	
	if InStr(itemDesc, "mortal"){
		return "fragments"
	}
	
	return itemType
}

isIgnoredCell(x,y){
	for index, ignoredCoord in stashIgnore{
		if (x == ignoredCoord.1 && y == ignoredCoord.2)
		{
			return true
		}
	}
	return false
}

randomSleep(){
	Sleep, getRandomVariance(50,6)
}

getMouseCoordsX(x){
	newX := x * stepSize + x * stepGap
	return topLeftX + getRandomVariance(newX,10)
}

getMouseCoordsY(y){
	newY := y * stepSize + y * stepGap
	return topLeftY + getRandomVariance(newY,10)
}

getRandomVariance(value, variance){
	Random, rand, 1, variance
	offset := rand - Floor(variance/2)
	return value + offset	
}

;JSON LIB BELOW

/**
 * Lib: JSON.ahk
 *     JSON lib for AutoHotkey.
 * Version:
 *     v2.1.3 [updated 04/18/2016 (MM/DD/YYYY)]
 * License:
 *     WTFPL [http://wtfpl.net/]
 * Requirements:
 *     Latest version of AutoHotkey (v1.1+ or v2.0-a+)
 * Installation:
 *     Use #Include JSON.ahk or copy into a function library folder and then
 *     use #Include <JSON>
 * Links:
 *     GitHub:     - https://github.com/cocobelgica/AutoHotkey-JSON
 *     Forum Topic - http://goo.gl/r0zI8t
 *     Email:      - cocobelgica <at> gmail <dot> com
 */



/**
 * Class: JSON
 *     The JSON object contains methods for parsing JSON and converting values
 *     to JSON. Callable - NO; Instantiable - YES; Subclassable - YES;
 *     Nestable(via #Include) - NO.
 * Methods:
 *     Load() - see relevant documentation before method definition header
 *     Dump() - see relevant documentation before method definition header
 */
class JSON
{
	/**
	 * Method: Load
	 *     Parses a JSON string into an AHK value
	 * Syntax:
	 *     value := JSON.Load( text [, reviver ] )
	 * Parameter(s):
	 *     value      [retval] - parsed value
	 *     text    [in, ByRef] - JSON formatted string
	 *     reviver   [in, opt] - function object, similar to JavaScript's
	 *                           JSON.parse() 'reviver' parameter
	 */
	class Load extends JSON.Functor
	{
		Call(self, ByRef text, reviver:="")
		{
			this.rev := IsObject(reviver) ? reviver : false
		; Object keys(and array indices) are temporarily stored in arrays so that
		; we can enumerate them in the order they appear in the document/text instead
		; of alphabetically. Skip if no reviver function is specified.
			this.keys := this.rev ? {} : false

			static quot := Chr(34), bashq := "\" . quot
			     , json_value := quot . "{[01234567890-tfn"
			     , json_value_or_array_closing := quot . "{[]01234567890-tfn"
			     , object_key_or_object_closing := quot . "}"

			key := ""
			is_key := false
			root := {}
			stack := [root]
			next := json_value
			pos := 0

			while ((ch := SubStr(text, ++pos, 1)) != "") {		
				if InStr(" `t`r`n", ch)
					continue
				if !InStr(next, ch, 1)
					this.ParseError(next, text, pos)

				holder := stack[1]
				is_array := holder.IsArray

				if InStr(",:", ch) {
					next := (is_key := !is_array && ch == ",") ? quot : json_value

				} else if InStr("}]", ch) {
					ObjRemoveAt(stack, 1)
					next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"

				} else {
					if InStr("{[", ch) {
					; Check if Array() is overridden and if its return value has
					; the 'IsArray' property. If so, Array() will be called normally,
					; otherwise, use a custom base object for arrays
						static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
					
					; sacrifice readability for minor(actually negligible) performance gain
						(ch == "{")
							? ( is_key := true
							  , value := {}
							  , next := object_key_or_object_closing )
						; ch == "["
							: ( value := json_array ? new json_array : []
							  , next := json_value_or_array_closing )
						
						ObjInsertAt(stack, 1, value)

						if (this.keys)
							this.keys[value] := []
					
					} else {
						if (ch == quot) {
							i := pos
							while (i := InStr(text, quot,, i+1)) {
								value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")

								static tail := A_AhkVersion<"2" ? 0 : -1
								if (SubStr(value, tail) != "\")
									break
							}

							if (!i)
								this.ParseError("'", text, pos)

							  value := StrReplace(value,  "\/",  "/")
							, value := StrReplace(value, bashq, quot)
							, value := StrReplace(value,  "\b", "`b")
							, value := StrReplace(value,  "\f", "`f")
							, value := StrReplace(value,  "\n", "`n")
							, value := StrReplace(value,  "\r", "`r")
							, value := StrReplace(value,  "\t", "`t")

							pos := i ; update pos
							
							i := 0
							while (i := InStr(value, "\",, i+1)) {
								if !(SubStr(value, i+1, 1) == "u")
									this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))

								uffff := Abs("0x" . SubStr(value, i+2, 4))
								if (A_IsUnicode || uffff < 0x100)
									value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
							}

							if (is_key) {
								key := value, next := ":"
								continue
							}
						
						} else {
							value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)

							static number := "number", integer :="integer"
							if value is %number%
							{
								if value is %integer%
									value += 0
							}
							else if (value == "true" || value == "false")
								value := %value% + 0
							else if (value == "null")
								value := ""
							else
							; we can do more here to pinpoint the actual culprit
							; but that's just too much extra work.
								this.ParseError(next, text, pos, i)

							pos += i-1
						}

						next := holder==root ? "" : is_array ? ",]" : ",}"
					} ; If InStr("{[", ch) { ... } else

					is_array? key := ObjPush(holder, value) : holder[key] := value

					if (this.keys && this.keys.HasKey(holder))
						this.keys[holder].Push(key)
				}
			
			} ; while ( ... )

			return this.rev ? this.Walk(root, "") : root[""]
		}

		ParseError(expect, ByRef text, pos, len:=1)
		{
			static quot := Chr(34), qurly := quot . "}"
			
			line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
			col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
			msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
			,     (expect == "")     ? "Extra data"
			    : (expect == "'")    ? "Unterminated string starting at"
			    : (expect == "\")    ? "Invalid \escape"
			    : (expect == ":")    ? "Expecting ':' delimiter"
			    : (expect == quot)   ? "Expecting object key enclosed in double quotes"
			    : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
			    : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
			    : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
			    : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
			    :                      "Expecting JSON value(string, number, true, false, null, object or array)"
			, line, col, pos)

			static offset := A_AhkVersion<"2" ? -3 : -4
			throw Exception(msg, offset, SubStr(text, pos, len))
		}

		Walk(holder, key)
		{
			value := holder[key]
			if IsObject(value) {
				for i, k in this.keys[value] {
					; check if ObjHasKey(value, k) ??
					v := this.Walk(value, k)
					if (v != JSON.Undefined)
						value[k] := v
					else
						ObjDelete(value, k)
				}
			}
			
			return this.rev.Call(holder, key, value)
		}
	}

	/**
	 * Property: Undefined
	 *     Proxy for 'undefined' type
	 * Syntax:
	 *     undefined := JSON.Undefined
	 * Remarks:
	 *     For use with reviver and replacer functions since AutoHotkey does not
	 *     have an 'undefined' type. Returning blank("") or 0 won't work since these
	 *     can't be distnguished from actual JSON values. This leaves us with objects.
	 *     Replacer() - the caller may return a non-serializable AHK objects such as
	 *     ComObject, Func, BoundFunc, FileObject, RegExMatchObject, and Property to
	 *     mimic the behavior of returning 'undefined' in JavaScript but for the sake
	 *     of code readability and convenience, it's better to do 'return JSON.Undefined'.
	 *     Internally, the property returns a ComObject with the variant type of VT_EMPTY.
	 */
	Undefined[]
	{
		get {
			static empty := {}, vt_empty := ComObject(0, &empty, 1)
			return vt_empty
		}
	}

	class Functor
	{
		__Call(method, ByRef arg, args*)
		{
		; When casting to Call(), use a new instance of the "function object"
		; so as to avoid directly storing the properties(used across sub-methods)
		; into the "function object" itself.
			if IsObject(method)
				return (new this).Call(method, arg, args*)
			else if (method == "")
				return (new this).Call(arg, args*)
		}
	}
}

