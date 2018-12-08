
BODY, FRAMESET, FORM {
    margin: 0;
    padding: 0;
}

:focus {
    outline-color: orange;
}

INPUT, BUTTON, SELECT, TABLE, BODY, FRAMESET, TEXTAREA {
    font-size: 10pt;
    font-family: "Segoe UI","Helvetica Neue", Helvetica, Arial, sans-serif;
}

/* Override default link styling ie. on toolbar links */
.ActiveLink:link {
    color: black;
    text-decoration: none;
}

.ActiveLink:hover {
    color: black;
    text-decoration: underline;
}

.ActiveLink:visited {
    color: black;
    text-decoration: none;
}

.ActiveLink:visited:hover {
    color: black;
    text-decoration: underline;
}

/*
   Toolbar icons
*/

span.glyphui {/* Default styling of toolbar icons */
    margin: 6px;
    padding: 3px;
}

/*
    Wait spinnie
*/

.WaitControlBackground {
    cursor: wait;
    padding: 15px;
    border: 1px solid;
}

.WaitInfoCell {
    padding-left: 25px;
    padding-right: 25px;
    vertical-align: middle;
    text-align: center;
    white-space: nowrap;
}

.WaitText {
    font-weight: normal;
}

.CancelLinkDiv {
    margin-top: 3px;
}

.spinnie {
    position: relative;
    width: 60px;
    height: 60px;
    margin:auto;
    transform: scale(.4);
}

.spinnie .dot {
    position: absolute;
    width: 75px;
    height: 75px;
    opacity: 0;
    transform: rotate(225deg);
    animation: orbit 6.96s infinite;
}

.spinnie .dot:after{
    content: '';
    display: block;
    width: 10px;
    height: 10px;
    left:0px;
    top:0px;
    border-radius: 10px;
}

.spinnie .dot1 {
    animation-delay: 1.14s;
}

.spinnie .dot2 {
    animation-delay: 0.225s;
}

.spinnie .dot3 {
    animation-delay: 0.4575s;
}

.spinnie .dot4 {
    animation-delay: 0.6825s;
}

.spinnie .dot5 {
    animation-delay: 0.915s;
}

@keyframes orbit {
    0% {
        opacity: 1;
        z-index:99;
        transform: rotate(180deg);
        animation-timing-function: ease-out;
    }

    7% {
        opacity: 1;
        transform: rotate(300deg);
        animation-timing-function: linear;
        origin:0%;
    }

    30% {
        opacity: 1;
        transform:rotate(410deg);
        animation-timing-function: ease-in-out;
        origin:7%;
    }

    39% {
        opacity: 1;
        transform: rotate(645deg);
        animation-timing-function: linear;
        origin:30%;
    }

    70% {
        opacity: 1;
        transform: rotate(770deg);
        animation-timing-function: ease-out;
        origin:39%;
    }

    75% {
        opacity: 1;
        transform: rotate(900deg);
        animation-timing-function: ease-out;
        origin:70%;
    }

    76% {
    opacity: 0;
        transform:rotate(900deg);
    }

    100% {
    opacity: 0;
        transform: rotate(900deg);
    }
}

/*
    Paramater region
*/

.ParametersFrame {
    border: 1px solid;
}

.InterParamPadding { /* Spacing between param inputs */
    padding-left: 22px;
}

.EmptyDropDown {
    width: 15ex;
}

.SubmitButtonCell {
    border-left: 1px solid #868686;
    align: center;
    text-align: center;
    padding: 10px;
    vertical-align: top;
}

.ParamEntryCell input {
    vertical-align: middle;
}

.ParametersFrame .glyphui {
    padding: 2;
    margin: 2;
}

.ParametersFrame .glyphui-downarrow {
    margin-left: 4px;
    font-size: 12px;
}

.ParamEntryCell .glyphui {
    display: inline;
    padding: 5px;
}

/*
    Generic toolbar
*/

.ToolBarButtonsCell { /* Basic toolbar icons */
    padding: 0;
    border-bottom: 1px solid;
    border-top: 1px solid;
    border-left: none;
    border-right: none;
}

.ToolbarPageNav input {
    display: inline;
    margin: 4px;
    padding: 1px;
}

.ToolbarFind,
.ToolbarZoom {
    display: inline;
    padding-top: 10px;
    padding-left: 16px;
    padding-right: 16px;
}

.ToolbarExport.WidgetSet:hover,
.ToolbarRefresh.WidgetSet:hover,
.ToolbarPrint.WidgetSet:hover,
.ToolbarBack.WidgetSet:hover,
.ToolbarPageNav.WidgetSet .HoverButton:hover,
.ToolbarPowerBI.WidgetSet:hover {
    cursor: pointer;
}

.ToolbarExport.WidgetSet,
.ToolbarFind.WidgetSet,
.ToolbarZoom.WidgetSet,
.ToolbarPageNav.WidgetSet,
.ToolbarRefresh.WidgetSet,
.ToolbarPrint.WidgetSet,
.ToolbarBack.WidgetSet,
.ToolbarPowerBI.WidgetSet {
    border-width: 0 1px 0 0;
    border-style: solid;
}

.ToolbarPageNav.WidgetSet input, .ToolbarFind.WidgetSet input {
    border: 1px solid silver;
    line-height: normal;
}

.ToolbarZoom.WidgetSet select {
    border: 1px solid silver;
    line-height: normal;
    position: relative;
    top: -1px;
}

.ToolbarRefresh.WidgetSet,
.ToolbarPrint.WidgetSet,
.ToolbarBack.WidgetSet,
.ToolbarPowerBI.WidgetSet {
    height: 46px;
    width: 56px;
}

.ShowHideParametersGroup {
    padding-right: 4px;
}

.ToolbarFind .InterWidgetGroup,
.ToolbarPageNav .InterWidgetGroup {
    padding-right: 4px;
}

.DisabledLink {
    color: #212121;
    text-decoration: none;
    cursor: default;
}

.DisabledLink:hover {
    color: gray;
    text-decoration: none;
    cursor: default;
}

.ImageWidget {
    height: 16px;
    width: 16px;
    margin: 0;
}

.DisabledTextBox {
    background-color: #FFFFFF;
}

.WidgetSet {
    height: 46px;
    text-align:center;
}

.WidgetSetSpacer {
    padding-right: 20px;
}

.HoverButton {
    height:46px;
    cursor: hand;
    border: 0;
    padding: 0;
    margin: 0;
}

.NormalButton {
    height:46px;
    cursor: hand;
}

.NormalButton table,
.HoverButton table,
.aspNetDisabled table {
    width: 56px;
}

.DisabledButton {
    height:46px;
    cursor: default;
}

/*
    Export drop down 
*/

.ToolbarExport,
.ToolbarExport table,
.ToolbarExport .MenuBarBkGnd {
    width: 80px; /* Width of the Export button */
}

.ToolbarExport .glyphui-save {
    margin-right: 0px;
}

.ToolbarExport .glyphui-downarrow {
    margin-left: 0px;
}

.ToolbarExport .MenuBarBkGnd {
    width: 200px; /* Width of the Export drop down */
}

.ToolbarExport .MenuBarBkGnd .DisabledButton,
.ToolbarExport .MenuBarBkGnd .HoverButton {
    padding-top: 6px; /* Force vertical alignment of drop down text */
    padding-left: 10px;
    text-align: left; /* Override the default center alignment of toolbar content */
    overflow: hidden;
}

.ToolbarExport .MenuBarBkGnd .HoverButton {
    cursor: pointer;
}

.ToolbarExport .MenuBarBkGnd div:first-of-type {
    border-width: 1px 1px 1px 1px; /* The first export menu drop down needs to specify a top border */
}

.ToolbarExport .MenuBarBkGnd div { /* Border of items in the drop down menu */
    border-width: 0 1px 1px 1px;
    border-style: solid;
}

.ToolbarExport .MenuBarBkGnd div:nth-last-of-type(1) {
    border-width: 0; /* The last export menu doesn't need to specify a border */
}

.ToolbarExport .MenuBarBkGnd .HoverButton { /* Hover effect on drop down menu items */
    background-color: #F4F4F4;
}

.ToolbarExport :focus {
    outline-style: none; /* Remove browser hover effect */
}

/*
    Document map
*/

.DocMapFrame,
.DocMapTitle {
    border-bottom: 1px solid; /* Border of the document map region */
}

.DocMapBar { /* Sizing of the document map title */
    padding-right: 10px;
    padding-left: 10px;
    height: 28px;
    line-height: 28px;
}

.DocMapContentCell > div > div div { /* Doc map entry */
    margin-top: 6px;
}

.DocMapContentCell  a span {
    padding: 3px;
}

.ToolbarDocMapToggle {
    display: inline;
}

.DocMapFrame a {
    color: black;
}
