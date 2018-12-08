//----------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
//----------------------------------------------------------------------------

function ResizeVerticalTextBoxes() {
    if (window.jQuery) {
        $(".canGrowVerticalTextBox").each(function() {
            var node = $(this);
            var child = node.children(":first");
            var td = node.parent();
            
            if (child.width() > node.width())
            {
                td.width(child.outerWidth());
                node.width(child.outerWidth());
            }
            else if (!node.hasClass("canShrinkVerticalTextBox"))
            {
                child.outerWidth(node.width());
            }
        });
        
        $(".canShrinkVerticalTextBox").each(function() {
            var node = $(this);
            var child = node.children(":first");
            var td = node.parent();
            
            if (child.width() < node.width())
            {
                td.width(child.outerWidth());
                node.width(child.outerWidth());
            }
            else
            {
                child.outerWidth(node.width());
            }
        });
    }
}

function ResizeTablixRows() {
    if (window.jQuery) {
        MarkCanGrowRows();
        MarkCanShrinkRows();

        // Fix for slow code...
        // The original code here was querying the child and node height and setting the grandparent height in the same iteration.
        // This caused a layout reflow to occur with every iteration. Which was slow. 
        // The fix breaks the two operations apart so the layout reflow does not occur. 

        var elementsThatNeedHeightCleared = $(".cannotGrowTextBoxInTablix").map(function () {
            var node = $(this);
            var child = node.children().first();
            var childHeight = child.height();
            var grandparent = node.parent().parent();

            // Fix for Vertical Alignment not working when a tablix row contains a mix of CanGrow and CannotGrow
            // - node.height represents the height of the row after others have grown.
            // - childHeight represents the height that the text wants to achieve.
            // If the height that the child wants to achieve is smaller than the height of the row, we will take off 
            // the original height of the grandparent to allow vertical alignment.
            if (node.height() > childHeight) {
                return grandparent;
            } else {
                return null;
            }
        });

        elementsThatNeedHeightCleared.each(function (index, element) {
                element.css('height', '');
            });
    }
}

function MarkCanGrowRows() {
    if (window.jQuery) {
        if ($(".cannotGrowTextBoxInTablix").length === 0 || $(".canGrowTextBoxInTablix").length === 0)
        {
            return;
        }
        
        $("tr > td > .canGrowTextBoxInTablix").parent().parent().each(function() {
            var row = $(this);
            if (row.find('.canGrowTextBoxInTablix').length === 0 || row.find('.cannotGrowTextBoxInTablix').length === 0)
            {
                return; //continue;
            }
            else {
                row.find('.cannotGrowTextBoxInTablix').each(function () {
                    $(this).parent().addClass("tdResizable");
                })
            }
        });		
    }
}

function MarkCanShrinkRows() {
    if (window.jQuery) {
        if ($(".canShrinkTextBoxInTablix").length === 0)
        {
            return;
        }
        
        $("tr > td > .canShrinkTextBoxInTablix").parent().parent().each(function() {
            var row = $(this);
            if (row.find(".canShrinkTextBoxInTablix").length === 0)
            {
                return; //continue;
            }
            else if (row.find(".cannotShrinkTextBoxInTablix").length === 0){
                row.find('td').each(function () {
                    $(this).addClass("tdResizable");
                })
            }
        });		
    }
}

function Resize100HeightElements() {
    if (window.jQuery) {
        $(".resize100Height").each(function () {

            var self = $(this);
            var parent = self.parent();

            var parentHeight = parent.height();
            while (!(parent.is("div") || parent.is("td") || parent.is("tr")) || parentHeight === 0) {
                parent = parent.parent();
                parentHeight = parent.height();
            }

            self.height(parentHeight);
        });
    }
}

function Resize100WidthElements() {
    if (window.jQuery) {
        $(".resize100Width").each(function () {

            var self = $(this);
            var parent = self.parent();

            var parentWidth = parent.width();
            while (!(parent.is("div") || parent.is("td") || parent.is("tr")) || parentWidth === 0) {
                parent = parent.parent();
                parentWidth = parent.width();
            }

            self.width(parentWidth);
        });
    }
}



function PostRenderActions() {
    Resize100HeightElements();
    Resize100WidthElements();
    ResizeVerticalTextBoxes();
    ResizeTablixRows();
}

// Note: Make sure this script follow RVC jquery in script registration.
window.$RSjQuery = window.jQuery;
