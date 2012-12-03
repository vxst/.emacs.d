(setq css-eldoc-hash-table #s(hash-table size 145 test equal rehash-size 1.5 rehash-threshold 0.8 data ("azimuth" "<angle> | [[ left-side | far-left | left | center-left | center | center-right | right | far-right | right-side ] || behind ] | leftwards | rightwards | inherit" "background" "['background-color' || 'background-image' || 'background-repeat' || 'background-attachment' || 'background-position'] | inherit" "background-attachment" "scroll | fixed | inherit" "background-color" "color | transparent | inherit" "background-image" "uri | none | inherit" "background-position" "[ [ <percentage> | <length> | left | center | right ] [ <percentage> | <length> | top | center | bottom ]? ] | [ [ left | center | right ] || [ top | center | bottom ] ] | inherit" "background-repeat" "repeat | repeat-x | repeat-y | no-repeat | inherit" "border" "width sytle color" "border-top" "width sytle color" "border-bottom" "width sytle color" "border-left" "width sytle color" "border-right" "width sytle color" "border-collapse" "collapse | separate | inherit" "border-color" "[color | transparent]{1,4} | inhert" "border-spacing" "<length> <length>? | inherit" "border-style" "<border-style>{1,4} | inherit" "border-top-style" "style | inherit" "border-right-style" "style | inherit" "border-bottom-style" "style | inherit" "border-left-style" "style | inherit" "border-top-width" "width | inherit" "border-bottom-width" "width | inherit" "border-right-width" "width | inherit" "border-left-width" "width | inherit" "border-width" "width{1,4} | inherit" "bottom" "length | percentage | auto | inherit" "caption-side" "top | bottom | inherit" "clear" "none | left | right | both | inherit" "clip" "<shape> | auto | inherit" "color" "color | inherit" "content" "normal | none | [ <string> | <uri> | <counter> | attr(<identifier>) | open-quote | close-quote | no-open-quote | no-close-quote ]+ | inherit" "counter-increment" "[ <identifier> <integer>? ]+ | none | inherit" "counter-reset" "[ <identifier> <integer>? ]+ | none | inherit" "cue-after" "<uri> | none | inherit" "cue-before" "<uri> | none | inherit" "cue" "[cue-before || cue-after] | inherit" "cursor" "[ [<uri> ,]* [ auto | crosshair | default | pointer | move | e-resize | ne-resize | nw-resize | n-resize | se-resize | sw-resize | s-resize | w-resize | text | wait | help | progress ] ] | inherit" "direction" "ltr | rtl | inherit" "display" "inline | block | list-item | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit" "elevation" "<angle> | below | level | above | higher | lower | inherit" "empty-cells" "show | hide | inherit" "float" "left | right | none | inherit" "font-family" "[[ <family-name> | <generic-family> ] [, <family-name>| <generic-family>]* ] | inherit" "font-size" "<size> | inherit" "font-style" "normal | italic | oblique | inherit" "font-variant" "normal | small-caps | inherit" "font-weight" "normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit" "font" "[ [ 'font-style' || 'font-variant' || 'font-weight' ]? 'font-size' [ / 'line-height' ]? 'font-family' ] | caption | icon | menu | message-box | small-caption | status-bar | inherit" "height" "<length> | <%> | auto | inherit" "left" "<length> | <percentage> | auto | inherit" "letter-spacing" "normal | <length> | inherit" "line-height" "normal | <number> | <length> | <percentage> | inherit" "list-style-image" "<uri> | none | inherit" "list-style-position" "inside | outside | inherit" "list-style-type" "disc | circle | square | decimal | decimal-leading-zero | lower-roman | upper-roman | lower-greek | lower-latin | upper-latin | armenian | georgian | lower-alpha | upper-alpha | none | inherit" "list-style" "[ 'list-style-type' || 'list-style-position' || 'list-style-image' ] | inherit" "margin-right" "width | inherit" "margin-left" "width | inherit" "margin-top" "width | inherit" "margin-bottom" "width | inherit" "margin" "value || top/bottom left/right || top right bottom left" "max-height" "<length> | <percentage> | none | inherit" "max-width" "<length> | <percentage> | none | inherit" "min-height" "<length> | <percentage> | inherit" "min-width" "<length> | <percentage> | inherit" "orphans" "<int> | inherit" "outline-color" "<color> | invert | inherit" "outline-style" "<border-style> | inherit" "outline-width" "<border-width> | inherit" "outline" "[ 'outline-color' || 'outline-style' || 'outline-width' ] | inherit" "overflow" "visible | hidden | scroll | auto | inherit" "padding-top" "<width> | inherit" "padding-bottom" "<width> | inherit" "padding-left" "<width> | inherit" "padding-right" "<width> | inherit" "padding" "value || top/bottom left/right || top right bottom left" "page-break-after" "auto | always | avoid | left | right | inherit" "page-break-before" "auto | always | avoid | left | right | inherit" "page-break-inside" "avoid | auto | inherit" "pause-after" "<time> | <%> | inherit" "pause-befote" "<time> | <%> | inherit" "pause" "[[<time> | <%> ] {1,2}] | inherit ]" "pitch-range" "<number> | inherit" "pitch" "<frequency> | x-low | low | medium | high | x-high | inherit" "play-during" "<uri> [ mix || repeat ]? | auto | none | inherit" "position" "static | relative | absolute | fixed | inherit" "quotes" "[<string> <string>]+ | none | inherit" "richness" "<num> | inherit" "right" "<length> | <percentage> | auto | inherit" "speak-header" "once | always | inherit" "speak-numeral" "digits | continuous | inherit" "speak-punctuation" "code | none | inherit" "speak" "normal | none | spell-out | inherit" "speech-rate" "<number> | x-slow | slow | medium | fast | x-fast | faster | slower | inherit" "stress" "<num> | inherit" "text-align" "left | right | center | justify | inherit" "text-decoration" "none | [ underline || overline || line-through || blink ] | inherit" "text-indent" "<length> | <%> | inherit" "text-transform" "capitalize | uppercase | lowercase | none | inherit" "top" "<length> | <percentage> | auto | inherit" "transition" "[<'transition-property'> || <'transition-duration'> || <'transition-timing-function'> || <'transition-delay'> [, [<'transition-property'> || <'transition-duration'> || <'transition-timing-function'> || <'transition-delay'>]]* " "unicode-bidi" "normal | embed | bidi-override | inherit" "vertical-align" "baseline | sub | super | top | text-top | middle | bottom | text-bottom | <percentage> | <length> | inherit" "visibility" "visible | hidden | collapse | inherit" "voice-family" "[[<specific-voice> | <generic-voice> ],]* [<specific-voice> | <generic-voice> ] | inherit" "volume" "<number> | <percentage> | silent | x-soft | soft | medium | loud | x-loud | inherit" "white-space" "normal | pre | nowrap | pre-wrap | pre-line | inherit" "windows" "<int> | inherit" "width" "<length> | <percentage> | auto | inherit" "word-spacing" "normal | <length> | inherit" "z-index" "auto | <int> | inherit")))(provide 'css-eldoc-hash-table)
