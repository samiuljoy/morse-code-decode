#!/usr/bin/env sh

# functions

# Usage function
usage() {
	echo "sh morse.sh -e 'this is a toy'  =  encode into morse code"
	echo "sh morse.sh -d '- .... .. ... .. ... -. - --- -.--'  = decode morse code to alphabets"
	echo "sh morse.sh -ea 'this is a toy' = encode into audio mp3 form"
}
## Decode function
decode() {
	[ "$i" = ".-" ] && echo a; [ "$i" = "-..." ] && echo b
	[ "$i" = "-.-." ] && echo c; [ "$i" = "-.." ] && echo d
	[ "$i" = "." ] && echo e; [ "$i" = "..-." ] && echo f
	[ "$i" = "--." ] && echo g; [ "$i" = "...." ] && echo h
	[ "$i" = ".." ] && echo i; [ "$i" = ".---" ] && echo j
	[ "$i" = "-.-" ] && echo k; [ "$i" = ".-.." ] && echo l
	[ "$i" = "--" ] && echo m; [ "$i" = "-." ] && echo n
	[ "$i" = "---" ] && echo o; [ "$i" = ".--." ] && echo p
	[ "$i" = "--.-" ] && echo q; [ "$i" = ".-." ] && echo r
	[ "$i" = "..." ] && echo s; [ "$i" = "-" ] && echo t
	[ "$i" = "..-" ] && echo u; [ "$i" = "...-" ] && echo v
	[ "$i" = ".--" ] && echo w; [ "$i" = "-..-" ] && echo x
	[ "$i" = "-.--" ] && echo y; [ "$i" = "--.." ] && echo z
	[ "$i" = "-----" ] && echo 0; [ "$i" = ".----" ] && echo 1
	[ "$i" = "..---" ] && echo 2; [ "$i" = "...--" ] && echo 3
	[ "$i" = "....-" ] && echo 4; [ "$i" = "....." ] && echo 5
	[ "$i" = "-..." ] && echo 6; [ "$i" = "--..." ] && echo 7
	[ "$i" = "---.." ] && echo 8; [ "$i" = "----." ] && echo 9
}
## Encode function
encode() {
	[ "$i" = "a" ] && echo ".-"; [ "$i" = "b" ] && echo "-..."
	[ "$i" = "c" ] && echo "-.-."; [ "$i" = "d" ] && echo "-.."
	[ "$i" = "e" ] && echo "."; [ "$i" = "f" ] && echo "..-."
	[ "$i" = "g" ] && echo "--."; [ "$i" = "h" ] && echo "...."
	[ "$i" = "i" ] && echo ".."; [ "$i" = "j" ] && echo ".---"
	[ "$i" = "k" ] && echo "-.-"; [ "$i" = "l" ] && echo ".-.."
	[ "$i" = "m" ] && echo "--"; [ "$i" = "n" ] && echo "-."
	[ "$i" = "o" ] && echo "---"; [ "$i" = "p" ] && echo ".--."
	[ "$i" = "q" ] && echo "--.-"; [ "$i" = "r" ] && echo ".-."
	[ "$i" = "s" ] && echo "..."; [ "$i" = "t" ] && echo "-"
	[ "$i" = "u" ] && echo "..-"; [ "$i" = "v" ] && echo "...-"
	[ "$i" = "w" ] && echo ".--"; [ "$i" = "x" ] && echo "-..-"
	[ "$i" = "y" ] && echo "-.--"; [ "$i" = "z" ] && echo "--.."
	[ "$i" = "0" ] && echo "-----"; [ "$i" = "1" ] && echo ".----"
	[ "$i" = "2" ] && echo "..---"; [ "$i" = "3" ] && echo "...--"
	[ "$i" = "4" ] && echo "....-"; [ "$i" = "5" ] && echo "....."
	[ "$i" = "6" ] && echo "-..."; [ "$i" = "7" ] && echo "--..."
	[ "$i" = "8" ] && echo "---.."; [ "$i" = "9" ] && echo "----."
}
## for-loop encoding
loop_encode() {
	for i in $(echo $val | sed 's/\(.\)/\1\n/g'); do
		encode
	done | tr '\n' ' '
}
## ffmpeg conversion
ffm_convert() {
	sed 's/\s/|blank/g; s/\./|dit/g; s/-/|dah/g; s/dit/dit.mp3/g; s/dah/dah.mp3/g;s/blank/blank.mp3/g' | \
		cut -c '2-' | \
		xargs -I '{}' ffmpeg -y -loglevel 8 -i "concat:{}" -acodec copy $output_filename
}
## ffmpeg tempo
ffm_tempo() {
	ffmpeg -y -loglevel 8 -i "$output_filename" -filter:a "atempo=1.5" -vn $final_filename
}
case "$1" in
	""|" " ) usage
		;;
	-d ) val="$2"
		for i in $val; do
			decode
		done | \
			tr '\n' ' ' && echo
		return 0;
		;;
	-e ) val="$2"
		loop_encode && echo
		return 0;
			;;
	-ea ) val="$2"
		
		# variable for initial output filename
		output_filename="output3.mp3"
		# variable for final output filename
		final_filename="final.mp3"

		loop_encode | ffm_convert && \
			ffm_tempo && loop_encode && \
			rm $output_filename && \
			echo
		return 0;
		;;
	* ) echo "invalid argument"
		usage
		;;
esac
