
/* Reset the box model to Quirks standard (borders and padding included in width) */
html {
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}
*, *:before, *:after {
  -webkit-box-sizing: inherit;
  -moz-box-sizing: inherit;
  box-sizing: inherit;
}

.tdResizable {
	height:100% !important;
	position:relative;
	overflow:hidden;
	background-clip: padding-box;
}

.tdResizable div.cannotGrowTextBoxInTablix {
	position:absolute;
	height:100% !important;
	max-height: initial !important;
	overflow: visible !important;
}

.tdResizable div.canShrinkTextBoxInTablix {
	position:static !important;
	height:100% !important;
}